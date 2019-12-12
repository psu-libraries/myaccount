# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SymphonyClient do
  let(:client) { subject }

  describe '#login' do
    before do
      stub_request(:post, "#{Settings.symws.url}/user/patron/login")
        .with(body: Settings.symws.login_params.to_h,
              headers: Settings.symws.headers)
        .to_return(body: { patronKey: Settings.symws.patron_key }.to_json)
    end

    it 'authenticates the user against symphony' do
      expect(client.login('fake_user', 'some_password')).to include 'patronKey' => 'some_patron_key'
    end
  end

  describe '#patron_info' do
    let(:user) do
      User.new(username: 'zzz123',
               name: 'Zeke',
               patron_key: 'some_patron_key',
               session_token: 'e0b5e1a3e86a399112b9eb893daeacfd')
    end

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
      end

      it 'requests the item details for holds' do
        client.patron_info(user, item_details: { holdRecordList: true })

        expect(WebMock).to have_requested(:get, "#{Settings.symws.url}/user/patron/key/some_patron_key")
          .with(query: hash_including(includeFields: match(/holdRecordList{.*,item{.*}}/)))
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
end
