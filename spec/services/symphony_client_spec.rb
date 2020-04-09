# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SymphonyClient do
  let(:client) { subject }
  let(:user) do
    User.new(username: 'zzz123',
             name: 'Zeke',
             patron_key: 'some_patron_key',
             session_token: 'e0b5e1a3e86a399112b9eb893daeacfd')
  end

  describe '#login' do
    before do
      stub_request(:post, "#{Settings.symws.url}/user/patron/login")
        .with(body: Settings.symws.login_params.to_h,
              headers: Settings.symws.headers)
        .to_return(body: { patronKey: Settings.symws.patron_key }.to_json)
    end

    it 'logins the user to symphony' do
      expect(client.login('fake_user', 'some_password')).to include 'patronKey' => 'some_patron_key'
    end
  end

  describe '#authenticate' do
    let(:auth_response) { { status: 200 } }

    before do
      stub_request(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
        .with(query: hash_including(includeFields: 'key'))
        .to_return(auth_response)
    end

    it 'authenticates the user against symphony' do
      expect(client.authenticate(user).status).to eq 200
    end

    context 'with a stale session' do
      let(:auth_response) { { status: 401 } }

      it 'does not authenticates the user against symphony' do
        expect(client.authenticate(user).status).to eq 401
      end
    end
  end

  describe '#patron_info' do
    before do
      stub_request(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
        .with(query: hash_including(includeFields: match(/\*/)))
        .to_return(body: { key: 'some_patron_key' }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.patron_info(user)).to include 'key' => 'some_patron_key'
    end

    context 'when requesting item details' do
      it 'requests the item details for checkouts' do
        client.patron_info(user, item_details: { circRecordList: true })

        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_including(includeFields: match(/circRecordList{.*,item{.*}}/)))
        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_excluding(includeFields: match(/blockList/)))
        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_excluding(includeFields: match(/holdRecordList/)))
      end

      it 'requests the item details for holds' do
        client.patron_info(user, item_details: { holdRecordList: true })

        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_including(includeFields: match(/holdRecordList{.*,item{.*}}/)))
        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_excluding(includeFields: match(/circRecordList/)))
        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_excluding(includeFields: match(/holdRecordList/)))
      end

      it 'requests the item details for fines' do
        client.patron_info(user, item_details: { blockList: true })

        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_including(includeFields: match(/blockList{.*,item{.*}}/)))
        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_excluding(includeFields: match(/circRecordList/)))
        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_excluding(includeFields: match(/holdRecordList/)))
      end
    end
  end

  describe '#change_pickup_library' do
    let(:symphony_response) { { status: 200 } }
    let(:change_pickup_library_response) { client.change_pickup_library(hold_key: 'a_hold_key',
                                                                        pickup_library: 'UP-PAT',
                                                                        session_token: user.session_token) }

    before do
      stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/changePickupLibrary')
        .with(body: { "holdRecord": {
                "resource": '/circulation/holdRecord',
                "key": 'a_hold_key'
              },
                      "pickupLibrary": {
                        "resource": '/policy/library',
                        "key": 'UP-PAT'
                      } })
        .to_return(symphony_response)
    end

    it 'successfully changes the pickup library' do
      expect(change_pickup_library_response.status).to eq 200
    end

    context 'when the web service does not respond with a 200' do
      let(:symphony_response) { { status: 400, body: error_prompt } }

      let(:error_prompt) do
        { messageList: [{ code: 'some_error_code', message: 'Some error message' }] }.to_json
      end

      it 'fails to change the pickup library' do
        expect(change_pickup_library_response.status).to eq 400
      end

      it 'returns an error message' do
        parsed_response = JSON.parse(change_pickup_library_response)
        expect(parsed_response['messageList'].first).to include 'message' => 'Some error message'
      end
    end
  end

  describe '#not_needed_after' do
    let(:symphony_response) { { status: 200 } }
    let(:not_needed_after_response) { client.not_needed_after(hold_key: 'a_hold_key',
                                                              fill_by_date: '2021-03-17',
                                                              session_token: user.session_token) }

    before do
      stub_request(:put, 'https://example.com/symwsbc/circulation/holdRecord/key/a_hold_key')
        .with(body: { "resource": '/circulation/holdRecord',
                      "key": 'a_hold_key',
                      "fields": {
                        "fillByDate": '2021-03-17'
                      } })
        .to_return(symphony_response)
    end

    it 'successfully updates the not needed after date' do
      expect(not_needed_after_response.status).to eq 200
    end

    context 'when the web service does not respond with a 200' do
      let(:symphony_response) { { status: 400, body: error_prompt } }

      let(:error_prompt) do
        { messageList: [{ code: 'some_error_code', message: 'Some error message' }] }.to_json
      end

      it 'fails to update the not needed after date' do
        expect(not_needed_after_response.status).to eq 400
      end

      it 'returns an error message' do
        expect(JSON.parse(not_needed_after_response)['messageList'].first).to include 'message' => 'Some error message'
      end
    end
  end

  describe '#renew_items' do
    before do
      stub_request(:post, "#{Settings.symws.url}/circulation/circRecord/renew")
        .with(body: { item: { resource: 'item', key: '123' } })
        .to_return(status: 200)
      stub_request(:post, "#{Settings.symws.url}/circulation/circRecord/renew")
        .with(body: { item: { resource: 'item', key: 'invalid' } })
        .to_return(status: 400, body: error_prompt)
      stub_request(:post, "#{Settings.symws.url}/circulation/circRecord/renew")
        .with(body: { item: { resource: 'item', key: 'invalid_custom' } })
        .to_return(status: 400, body: error_prompt_custom)
    end

    let(:checkouts) do
      [
        instance_double(Checkout, resource: 'item', item_key: '123', title: 'A'),
        instance_double(Checkout, resource: 'item', item_key: 'invalid', title: 'B'),
        instance_double(Checkout, resource: 'item', item_key: 'invalid_custom', title: 'C')
      ]
    end

    let(:error_prompt) do
      { messageList: [{ code: 'some_other_code', message: 'Item has holds' }] }.to_json
    end

    let(:error_prompt_custom) do
      { messageList: [{ code: 'hatErrorResponse.252', message: 'Item has holds' }] }.to_json
    end

    it 'returns all responses for individual renewal requests in symphony regardless of success or error' do
      renew_response = client.renew_items(user, [checkouts.first, checkouts.second])
      fail_response = { renewal: checkouts.second, sirsi_response: 'Item has holds' }
      success_response = { renewal: checkouts.first, sirsi_response: nil }

      expect(renew_response).to eq error: [fail_response],
                                   success: [success_response]
    end

    it 'returns customized error messages' do
      renew_response = client.renew_items(user, [checkouts.last])
      error_response = { renewal: checkouts.last, sirsi_response: 'Item has holds, cannot be renewed.' }

      expect(renew_response).to include error: [error_response]
    end

    context 'when error message in the response does not include expected fields' do
      let(:error_prompt_custom) { 'Item has holds' }.to_json

      it 'returns empty error message' do
        renew_response = client.renew_items(user, [checkouts.last])
        error_response = { renewal: checkouts.last, sirsi_response: '' }

        expect(renew_response).to include error: [error_response]
      end
    end
  end

  describe '#cancel_hold' do
    let(:symphony_response) { { status: 200 } }
    let(:cancel_hold_response) { client.cancel_hold('a_hold_key', user.session_token) }

    before do
      stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/cancelHold')
        .with(body: { holdRecord: {
                resource: '/circulation/holdRecord',
                key: 'a_hold_key'
              } })
        .to_return(symphony_response)
    end

    it 'successfully cancels the hold' do
      expect(cancel_hold_response.status).to eq 200
    end

    context 'when the web service does not respond with a 200' do
      let(:symphony_response) { { status: 400, body: error_prompt } }
      let(:error_prompt) do
        { messageList: [{ code: 'some_error_code', message: 'Some error message' }] }.to_json
      end

      it 'fails to cancel hold and returns an error message' do
        expect(JSON.parse(cancel_hold_response)['messageList'].first).to include 'message' => 'Some error message'
      end
    end
  end

  describe '#get_bib_info' do
    before do
      stub_request(:get, "#{Settings.symws.url}/catalog/bib/key/12345")
        .with(query: hash_including(includeFields: match(/\*,callList/)))
        .to_return(status: 200, body: '{"resource": "/catalog/bib"}', headers: {})
    end

    it 'returns the Symphony Client "catalog bib" resource type' do
      bib_response = client.get_bib_info '12345', user.session_token

      expect(bib_response.body.to_str).to include '/catalog/bib'
    end
  end

  describe '#place_hold' do
    before do
      stub_request(:post, uri)
        .with(body: { "itemBarcode": 'success_item_barcode',
                      "patronBarcode": '1234',
                      "pickupLibrary": {
                        "resource": '/policy/library',
                        "key": 'UP-PAT'
                      },
                      "holdType": 'TITLE',
                      "holdRange": 'SYSTEM',
                      "fillByDate": '2021-03-17' })
        .to_return(status: 200, body: { key: 'some_hold_key' }.to_json)

      stub_request(:post, uri)
        .with(body: { "itemBarcode": 'fail_item_barcode',
                      "patronBarcode": '1234',
                      "pickupLibrary": {
                        "resource": '/policy/library',
                        "key": 'UP-PAT'
                      },
                      "holdType": 'TITLE',
                      "holdRange": 'SYSTEM',
                      "fillByDate": '2021-03-17' })
        .to_return(status: 500, body: error_prompt)

      stub_request(:post, uri)
        .with(body: { "itemBarcode": 'no_date_item_barcode',
                      "patronBarcode": '1234',
                      "pickupLibrary": {
                        "resource": '/policy/library',
                        "key": 'UP-PAT'
                      },
                      "holdType": 'TITLE',
                      "holdRange": 'SYSTEM' })
        .to_return(status: 200, body: { key: 'other_hold_key' }.to_json)

      stub_request(:post, uri)
        .with(body: { "itemBarcode": 'records_in_use_barcode',
                      "patronBarcode": '1234',
                      "pickupLibrary": {
                        "resource": '/policy/library',
                        "key": 'UP-PAT'
                      },
                      "holdType": 'TITLE',
                      "holdRange": 'SYSTEM',
                      "fillByDate": '2021-03-17' })
        .to_return({ status: 500, body: error_prompt }, status: 200, body: { key: 'some_hold_key' }.to_json)
    end

    let(:uri) { "#{Settings.symws.url}/circulation/holdRecord/placeHold" }
    let(:patron) { instance_double(Patron, barcode: '1234', library: 'UP-PAT') }
    let(:hold_args) { { pickup_library: 'UP-PAT', pickup_by_date: '2021-03-17' } }
    let(:error_prompt) { { messageList: [{ code: 'some_error_code', message: 'Some error message' }] }.to_json }

    context 'when place hold is successful' do
      let(:item_barcode) { 'success_item_barcode' }

      it 'returns the hold key' do
        place_hold_response = client.place_hold(patron, user.session_token, item_barcode, hold_args)

        expect(JSON.parse(place_hold_response)).to include 'key' => 'some_hold_key'
      end
    end

    context 'when place hold fails' do
      let(:item_barcode) { 'fail_item_barcode' }

      it 'returns the reason as the error message' do
        place_hold_response = client.place_hold(patron, user.session_token, item_barcode, hold_args)

        expect(JSON.parse(place_hold_response)['messageList'].first).to include 'message' => 'Some error message'
      end
    end

    context 'when place hold does not include fill by date' do
      let(:item_barcode) { 'no_date_item_barcode' }

      it 'returns the hold key' do
        hold_args = { pickup_library: 'UP-PAT' }
        place_hold_response = client.place_hold(patron, user.session_token, item_barcode, hold_args)

        expect(JSON.parse(place_hold_response)).to include 'key' => 'other_hold_key'
      end
    end

    context 'when place hold return records in use error' do
      let(:item_barcode) { 'records_in_use_barcode' }
      let(:error_prompt) { { messageList: [{ code: 'hatErrorResponse.116', message: 'Records in use' }] }.to_json }

      it 'keeps trying for 5 seconds max until the record is not in use' do
        place_hold_response = client.place_hold(patron, user.session_token, item_barcode, hold_args)

        expect(JSON.parse(place_hold_response)).to include 'key' => 'some_hold_key'
      end
    end
  end

  describe '#get_hold_info' do
    before do
      stub_request(:get, uri)
        .with(query: hash_including(includeFields: include_fields))
        .to_return(status: 200, body: { resource: '/circulation/holdRecord' }.to_json)
    end

    let(:hold_key) { 'a_hold_key' }
    let(:uri) { "#{Settings.symws.url}/circulation/holdRecord/key/#{hold_key}" }
    let(:include_fields) { '*,item{*,bib{shadowed,title,author},call{*}}' }

    it 'returns the resource hold record' do
      hold_response = client.get_hold_info(hold_key, user.session_token)

      expect(JSON.parse(hold_response)).to include 'resource' => '/circulation/holdRecord'
    end
  end

  describe '#get_item_info' do
    before do
      stub_request(:get, uri)
        .with(query: hash_including(includeFields: include_fields))
        .to_return(status: 200, body: { resource: '/catalog/item' }.to_json)
    end

    let(:barcode) { 'a_barcode' }
    let(:uri) { "#{Settings.symws.url}/catalog/item/barcode/#{barcode}" }
    let(:include_fields) { '*,bib{shadowed,title,author},call{*}' }

    it 'returns the resource item record' do
      item_response = client.get_item_info(barcode, user.session_token)

      expect(JSON.parse(item_response)).to include 'resource' => '/catalog/item'
    end
  end

  describe '#get_all_locations' do
    before do
      stub_request(:get, 'https://example.com/symwsbc/policy/location/simpleQuery')
        .with(query: hash_including(includeFields: 'displayName,holdable'))
        .to_return(status: 200, body: ALL_LOCATIONS.to_json, headers: {})
    end

    it 'retrieves a list of all locations' do
      response = client.get_all_locations

      expect(JSON.parse(response)).to eq ALL_LOCATIONS
    end
  end
end
