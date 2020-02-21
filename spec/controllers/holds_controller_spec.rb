# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HoldsController, type: :controller do
  let(:mock_patron) { instance_double(Patron) }
  let(:holds) do
    [
      instance_double(Hold, key: '1', ready_for_pickup?: true, title: 'Some Great Book', call_number: 'ABC123',
                            bib_summary: 'Some Great Book (ABC123)'),
      instance_double(Hold, key: '2', ready_for_pickup?: false, title: 'Some Good Book', call_number: 'ABC124',
                            bib_summary: 'Some Good Book (ABC124)')
    ]
  end

  before do
    allow(controller).to receive(:patron).and_return(mock_patron)
  end

  context 'with unauthenticated user' do
    it 'goes to the application root' do
      get(:index)
      expect(response).to redirect_to root_url
    end
  end

  context 'with an authenticated request' do
    let(:user) do
      { username: 'zzz123',
        name: 'Zeke',
        patron_key: '1234567' }
    end

    before do
      warden.set_user(user)
      allow(mock_patron).to receive(:holds).and_return(holds)
    end

    it 'sends the right item details to the web service' do
      item_details = controller.send(:item_details)

      expect(item_details).to eq holdRecordList: true
    end

    it 'renders the index template' do
      get :index

      expect(response).to render_template 'index'
    end

    it 'assigns holds ready for pickup' do
      get :index

      expect(assigns(:holds_ready).count).to eq 1
    end

    it 'assigns holds not ready for pickup' do
      get :index

      expect(assigns(:holds_not_ready).count).to eq 1
    end

    describe '#update' do
      before do
        stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/changePickupLibrary')
          .to_return(status: 200, body: '', headers: {})
      end

      context 'when pickup_library param is sent and the web services call succeeds' do
        it 'updates the pickup library and sets the flash message' do
          patch :update, params: { id: 'multiple', pickup_library: 'Other library', hold_list: [2] }

          expect(flash[:success]).to match(/Success!.*pickup location was updated/)
        end
      end

      context 'when pickup_library param is sent and the web services call fails' do
        before do
          stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/changePickupLibrary')
            .to_return(status: 404, body: '', headers: {})
        end

        it 'fails to update the pickup library and sets the flash message' do
          patch :update, params: { id: 'multiple', pickup_library: 'Other library', hold_list: [2] }

          expect(flash[:error]).to match(/Sorry!.*pickup location was not updated/)
        end
      end

      context 'when not_needed_after param is sent and the webservice is responding with 200' do
        before do
          stub_request(:put, 'https://example.com/symwsbc/circulation/holdRecord/key/2')
            .to_return(status: 200, body: '', headers: {})
        end

        it 'and it\'s a date in the future, it updates the not needed after and sets the flash message' do
          date = Date.tomorrow.to_formatted_s('%Y-%m-%d')
          patch :update, params: { id: 'multiple', pickup_by_date: date, hold_list: [2] }

          expect(flash[:success]).to match(/Success!.*not needed after date was updated/)
        end

        it 'and it\'s a date in the past, it does not update the not needed after and sets the flash message' do
          patch :update, params: { id: 'multiple', pickup_by_date: '2020-01-21', hold_list: [2] }

          expect(flash[:error]).to match(/date that is in the past/)
        end
      end

      context 'when not_needed_after param is sent and the webservice is not responding with 200' do
        before do
          stub_request(:put, 'https://example.com/symwsbc/circulation/holdRecord/key/2')
            .to_return(status: 500, body: '', headers: {})
        end

        it 'and it\'s a date in the past, it does not update the not needed after and sets the flash message' do
          patch :update, params: { id: 'multiple', pickup_by_date: '2100-01-21', hold_list: [2] }

          expect(flash[:error]).to match(/Sorry!/)
        end
      end
    end

    describe '#destroy' do
      before do
        stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/cancelHold')
          .to_return(status: 200, body: '', headers: {})
      end

      context 'when everything is good' do
        it 'a delete is attempted and succeeds' do
          delete :destroy, params: { id: 'multiple', hold_list: [2] }

          expect(flash[:success]).to match(/Some Good Book/)
        end
      end

      context 'when the web service does not respond with a 200' do
        before do
          stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/cancelHold')
            .to_return(status: 400, body: 'A bad thing', headers: {})
        end

        it 'deletes holds and fails' do
          delete :destroy, params: { id: 'multiple', hold_list: [2] }

          expect(flash[:error]).to match(/Sorry!/)
        end
      end
    end

    describe '#new' do
      let(:bib) { build(:bib_with_holdables) }
      let(:response_body) { HOLDABLE_LOCATIONS_RAW_JSON }

      before do
        stub_request(:get, 'https://example.com/symwsbc/catalog/bib/key/1')
          .with(query: hash_including(includeFields: match(/\*,callList/)))
          .to_return(status: 200, body: bib.body.to_json, headers: {})

        stub_request(:get, 'https://example.com/symwsbc/policy/location/simpleQuery')
          .with(query: hash_including(includeFields: match(/displayName,holdable/)))
          .to_return(status: 200, body: response_body.to_json, headers: {})
      end

      it 'sends requests to the web service when the web service supplied data first' do
        post :new, params: { catkey: '1' }

        expect(assigns(:bib).holdables.count).to eq 8
      end
    end
  end
end
