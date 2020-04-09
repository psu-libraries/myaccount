# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HoldsController, type: :controller do
  let(:mock_patron) { instance_double(Patron, barcode: '123456789', library: 'UP_PAT') }

  let(:holds) do
    [
      instance_double(Hold, key: '1', ready_for_pickup?: true, title: 'Some Great Book', call_number: 'ABC123',
                            bib_summary: 'Some Great Book (ABC123)'),
      instance_double(Hold, key: '2', ready_for_pickup?: false, title: 'Some Good Book', call_number: 'ABC124',
                            bib_summary: 'Some Good Book (ABC124)')
    ]
  end

  let(:error_prompt) do
    { messageList: [{ code: 'some_error_code', message: 'Some error message' }] }.to_json
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
        patron_key: '1234567',
        session_token: 'e0b5e1a3e86a399112b9eb893daeacfd' }
    end

    let(:mock_client) do
      instance_double(SymphonyClient)
    end

    before do
      warden.set_user(user)
      allow(SymphonyClient).to receive(:new).and_return(mock_client)
      allow(mock_client).to receive(:ping?).and_return(true)
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
      let(:update_response) { instance_double(HTTP::Response, status: 200) }

      before do
        allow(mock_client).to receive(:change_pickup_library).and_return(update_response)
        allow(mock_client).to receive(:not_needed_after).and_return(update_response)
      end

      context 'when pickup_library param is sent and the web services call succeeds' do
        it 'updates the pickup library and sets the flash message' do
          patch :update, params: { id: 'multiple', pickup_library: 'Other library', hold_list: [2] }

          expect(flash[:success]).to match(/Success!.*pickup location was updated/)
        end
      end

      context 'when pickup_library param is sent and the web services call fails' do
        before do
          allow(update_response).to receive(:status).and_return 404
          allow(update_response).to receive(:body).and_return(error_prompt)
        end

        it 'fails to update the pickup library and sets the flash message' do
          patch :update, params: { id: 'multiple', pickup_library: 'Other library', hold_list: [2] }

          expect(flash[:error]).to match(/Sorry!.*pickup location was not updated/)
        end
      end

      context 'when not_needed_after param is sent and the webservice is responding with 200' do
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
          allow(update_response).to receive(:status).and_return 404
          allow(update_response).to receive(:body).and_return(error_prompt)
        end

        it 'and it\'s a date in the past, it does not update the not needed after and sets the flash message' do
          patch :update, params: { id: 'multiple', pickup_by_date: '2100-01-21', hold_list: [2] }

          expect(flash[:error]).to match(/Sorry!/)
        end
      end
    end

    describe '#destroy' do
      let(:cancel_response) { instance_double(HTTP::Response, status: 200) }

      before do
        allow(mock_client).to receive(:cancel_hold).and_return(cancel_response)
      end

      context 'when everything is good' do
        it 'a delete is attempted and succeeds' do
          delete :destroy, params: { id: 'multiple', hold_list: [2] }

          expect(flash[:success]).to match(/Some Good Book/)
        end
      end

      context 'when the web service does not respond with a 200' do
        before do
          allow(cancel_response).to receive(:status).and_return 400
          allow(cancel_response).to receive(:body).and_return(error_prompt)
        end

        it 'deletes holds and fails' do
          delete :destroy, params: { id: 'multiple', hold_list: [2] }

          expect(flash[:error]).to match(/Sorry!/)
        end
      end
    end

    describe '#new' do
      let(:form_builder) { instance_double(PlaceHoldForm::Builder) }
      let(:form_params) { {
        catkey: '1',
        title: 'How to Eat More Pizza',
        author: 'Samantha Smith',
        volumetric_calls: [],
        barcode: '2'
      } }

      before do
        allow(PlaceHoldForm::Builder).to receive(:new).and_return(form_builder)
        allow(form_builder).to receive(:generate).and_return(form_params)
      end

      it 'sends the form parameters to the view' do
        get :new

        expect(assigns(:place_hold_form_params)).to eq(form_params)
      end
    end

    describe '#create' do
      let(:place_hold_params) {
        { catkey: '1',
          pickup_library: 'UP_PAT',
          pickup_by_date: '2020-02-02' }
      }

      let(:place_hold_response) { instance_double(HTTP::Response) }

      before do
        allow(mock_client).to receive(:place_hold).and_return(place_hold_response)
      end

      context 'when placing hold to an item that has no volumes and user already has a hold placed on' do
        let(:error_response) { { "messageList": [{ 'message': 'User already has a hold on this material' }] } }

        before do
          place_hold_params['barcodes'] = 'not_holdable_barcode'
          allow(place_hold_response).to receive(:status).and_return 500
          allow(place_hold_response).to receive(:body).and_return error_response.to_json
        end

        it 'sets the barcode and an error message in session' do
          post :create, params: place_hold_params

          expect(session[:place_hold_results][:error].first).to include(
            barcode: 'not_holdable_barcode',
            error_message: 'User already has a hold on this material'
          )
        end

        it 'sets the catkey in session' do
          post :create, params: place_hold_params

          expect(session[:place_hold_catkey]).to eq '1'
        end

        it 'redirects to result page' do
          post :create, params: place_hold_params

          expect(response).to redirect_to result_path
        end
      end

      context 'when placing hold to a holdable item that has no volumes' do
        let(:success_response) {
          { "holdRecord": { "key": 'a_hold_key' } }
        }

        before do
          place_hold_params['barcodes'] = 'a_holdable_barcode'
          allow(place_hold_response).to receive(:status).and_return 200
          allow(place_hold_response).to receive(:body).and_return success_response.to_json
        end

        it 'sets the barcode and the hold key in session' do
          post :create, params: place_hold_params

          expect(session[:place_hold_results][:success].first).to include(
            barcode: 'a_holdable_barcode',
            hold_key: 'a_hold_key'
          )
        end
      end

      context 'when placing multiple hold requests at once' do
        let(:place_hold_response_1) { instance_double(HTTP::Response, status: 200, body: success_response_1) }
        let(:place_hold_response_2) { instance_double(HTTP::Response, status: 200, body: success_response_2) }
        let(:place_hold_response_3) { instance_double(HTTP::Response, status: 400, body: error_response) }
        let(:success_response_1) { { "holdRecord": { "key": 'hold_key_1' } }.to_json }
        let(:success_response_2) { { "holdRecord": { "key": 'hold_key_2' } }.to_json }
        let(:error_response) { { "messageList": [{ 'message': 'User already has a hold on this material' }] }.to_json }

        let(:place_hold_results) { {
          success: [{ barcode: 'holdable_barcode_1', hold_key: 'hold_key_1' },
                    { barcode: 'holdable_barcode_2', hold_key: 'hold_key_2' }],
          error: [{ barcode: 'not_holdable_barcode', error_message: 'User already has a hold on this material' }]
        } }

        before do
          allow(mock_client).to receive(:place_hold)
            .and_return(place_hold_response_1, place_hold_response_2, place_hold_response_3)
          place_hold_params['barcodes'] = ['holdable_barcode_1', 'holdable_barcode_2', 'not_holdable_barcode']
        end

        it 'sets the barcodes and the hold keys in session' do
          post :create, params: place_hold_params

          expect(session[:place_hold_results]).to eq place_hold_results
        end
      end

      context 'when placing hold with missing barcode params' do
        before do
          post :create, params: place_hold_params
        end

        it 'redirects to the new hold page' do
          expect(response).to redirect_to new_hold_path(catkey: '1')
        end

        it 'sets a flash error message' do
          expect(flash[:error]).to match(/select a volume/)
        end
      end

      context 'when placing hold with missing pickup location' do
        before do
          post :create, params: { catkey: '1', barcodes: '1', pickup_by_date: '02/02/2020' }
        end

        it 'redirects to the new hold page' do
          expect(response).to redirect_to new_hold_path(catkey: '1')
        end

        it 'sets a flash error message' do
          expect(flash[:error]).to match(/choose a pickup location/)
        end
      end

      context 'when placing hold with missing not needed after date' do
        before do
          post :create, params: { catkey: '1', barcodes: '1', pickup_library: 'UP_PAT' }
        end

        it 'redirects to the new hold page' do
          expect(response).to redirect_to new_hold_path(catkey: '1')
        end

        it 'sets a flash error message' do
          expect(flash[:error]).to match(/choose a not needed after date/)
        end
      end
    end

    describe '#result' do
      # HOLD_LOOKUP_RAW_JSON and ITEM_LOOKUP_RAW_JSON are mocked SymphonyClient responses
      let(:hold_info_response) { HOLD_LOOKUP_RAW_JSON.to_json }
      let(:item_info_response) { ITEM_LOOKUP_RAW_JSON.to_json }
      let(:hold_info) { instance_double(HTTP::Response, status: 200, body: hold_info_response) }
      let(:item_info) { instance_double(HTTP::Response, status: 200, body: item_info_response) }
      let(:mock_client) do
        instance_double(SymphonyClient, get_hold_info: hold_info, get_item_info: item_info)
      end
      let(:results) { {
        success: [{ barcode: 'holdable_barcode', hold_key: 'a_hold_key' }],
        error: [{ barcode: 'not_holdable_barcode', error_message: 'User already has a hold on this material' }]
      } }

      it 'redirects to holds page if empty results' do
        get :result

        expect(response).to redirect_to holds_path
      end

      it 'assigns place hold catkey' do
        get :result, params: {}, session: { place_hold_catkey: '1', place_hold_results: results }

        expect(assigns(:place_hold_catkey)).to eq '1'
      end

      it 'assigns place hold results for both placed and failed holds' do
        get :result, params: {}, session: { place_hold_catkey: '1', place_hold_results: results }

        expect(assigns(:place_hold_results).count).to eq 2
      end

      it 'assigns placed holds results correctly' do
        get :result, params: {}, session: { place_hold_catkey: '1', place_hold_results: results }

        placed_hold = assigns(:place_hold_results)[:success].first[:placed_hold]
        expect(placed_hold.record['key']).to eq 'a_hold_key'
      end

      it 'assigns failed holds results correctly' do
        get :result, params: {}, session: { place_hold_catkey: '1', place_hold_results: results }

        failed_hold = assigns(:place_hold_results)[:error].first[:failed_hold]
        expect(failed_hold.record['fields']['barcode']).to eq 'not_holdable_barcode'
      end
    end
  end
end
