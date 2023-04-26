# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IllController do
  let(:mock_patron) do
    instance_double(Patron, barcode: '12345678', email_address: 'abc123@psu.edu', profile: 'profile',
                            last_name: 'smith', first_name: 'bob', id: 'abc123', library: 'UP_PAT',
                            key: '1234567', ill_ineligible?: ill_ineligible,
                            standing_human:)
  end
  let(:bib) { instance_double(Bib, title: 'Some Great Book', author: 'Great Author', shadowed?: false) }
  let(:ill_ineligible) { false }
  let(:standing_human) { '' }

  before do
    allow(controller).to receive(:patron).and_return(mock_patron)
    stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Users/abc123")
      .with(
        headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key }
      )
      .to_return(status: 200, body: {}.to_json, headers: {})
  end

  context 'with an authenticated request' do
    let(:user) do
      { username: 'zzz123',
        name: 'Zeke',
        patron_key: '1234567',
        session_token: 'e0b5e1a3e86a399112b9eb893daeacfd' }
    end
    let(:mock_client) { instance_double(SymphonyClient) }

    before do
      warden.set_user(user)
      allow(SymphonyClient).to receive(:new).and_return(mock_client)
      allow(mock_client).to receive(:ping?).and_return(true)
      allow(controller).to receive(:bib_info).and_return(bib)
    end

    describe '#new' do
      let(:form_builder) { instance_double(PlaceHoldForm::Builder) }

      form_params = {
        catkey: '1',
        title: 'Some Great Book',
        author: 'Great Author'
      }

      before do
        allow(PlaceHoldForm::Builder).to receive(:new).and_return(form_builder)
        allow(form_builder).to receive(:generate).and_return(form_params)
      end

      context 'when a user needs created' do
        before do
          stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Users/abc123")
            .with(headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
            .to_return(status: 404, body: {}.to_json, headers: {})
          stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Users")
            .to_return(status: 200)
        end

        it 'creates a user and places a hold' do
          get :new, params: { catkey: 1 }

          expect(response).to redirect_to summaries_path
        end
      end

      context 'when patron is in bad standing' do
        before do
          stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Users/abc123")
            .with(headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
            .to_return(status: 200, body: { Cleared: 'BO' }.to_json, headers: {})
        end

        it 'redirects to holds' do
          get :new, params: { catkey: 1 }

          expect(response).to redirect_to new_hold_path(catkey: 1)
        end
      end

      context 'when patron is barred' do
        let(:standing_human) { 'The user is BARRED.' }

        it 'sets a flash error message' do
          get :new, params: {}

          expect(flash[:error]).to eq I18n.t('myaccount.hold.new_hold.patron_barred')
        end

        it 'redirects to the summaries' do
          get :new, params: {}

          expect(response).to redirect_to summaries_path
        end
      end

      context 'when patron is delinquent' do
        let(:standing_human) { 'The user is DELINQUENT.' }

        it 'sends the form parameters to the view' do
          get :new, params: { catkey: 1 }

          expect(assigns(:place_loan_form_params)).to eq(form_params)
        end
      end

      context 'when catkey param is missing' do
        it 'sets a flash error message' do
          get :new, params: {}

          expect(flash[:error]).to eq I18n.t('myaccount.hold.new_hold.catkey_missing')
        end

        it 'redirects to the summaries' do
          get :new, params: {}

          expect(response).to redirect_to summaries_path
        end
      end

      context 'when user tries with a non holdable record' do
        form_params = {}

        it 'sets a flash error message' do
          get :new, params: { catkey: 1 }

          expect(flash[:error]).to eq I18n.t('myaccount.hold.new_hold.error_html')
        end

        it 'redirects to the summaries' do
          get :new, params: { catkey: 1 }

          expect(response).to redirect_to summaries_path
        end
      end

      context 'when the site is in maintenance mode' do
        after do
          Settings.maintenance_mode = false
        end

        it 'returns redirects to the homepage' do
          Settings.maintenance_mode = true

          put :new, params: { catkey: 1 }

          expect(response).to redirect_to root_path
        end
      end

      context 'when patron is ILLiad elligible' do
        it 'assigns the form parameters' do
          get :new, params: { catkey: 1 }

          expect(assigns(:place_loan_form_params)).to eq(form_params)
        end
      end

      context 'when patron is ILLiad inelligible' do
        let(:ill_ineligible) { true }

        it 'redirects to holds/new' do
          get :new, params: { catkey: 1 }

          expect(response).to redirect_to new_hold_path(catkey: 1)
        end
      end
    end

    describe '#create' do
      let(:place_loan_form_params) {
        {
          catkey: '1',
          pickup_by_date: '2022-12-02',
          accept_alternate_edition: 'true'
        }
      }

      let(:ill_transaction) { instance_double(IllTransaction,
                                              request_type: 'Loan',
                                              process_type: 'Borrowing',
                                              loan_title: 'Some Great Book',
                                              loan_author: 'Great Author',
                                              isbn: '1234567',
                                              username: 'xyz12',
                                              loan_publisher: 'Great Publisher',
                                              loan_place: 'The Great Place',
                                              loan_date: '2022-11-01',
                                              loan_edition: 'Test Edition') }

      let(:request_body) do
        {
          Username: 'xyz12',
          RequestType: 'Loan',
          LoanAuthor: 'Great Author',
          ISSN: '1234567',
          LoanPublisher: 'Great Publisher',
          LoanPlace: 'The Great Place',
          LoanDate: '2022-11-01',
          LoanTitle: 'Some Great Book',
          LoanEdition: 'Test Edition',
          ProcessType: 'Borrowing',
          NotWantedAfter: '2022-12-02',
          AcceptAlternateEdition: true,
          ItemInfo1: false,
          ItemInfo2: ''
        }
      end

      before do
        allow(IllTransaction).to receive(:new).and_return(ill_transaction)
      end

      after do
        Redis.current.flushall
      end

      context 'when place loan successful' do
        before do
          stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Users/abc123")
            .with(headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
            .to_return(status: 200, body: {}.to_json)
          stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/")
            .with(body: request_body,
                  headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
            .to_return(status: 200, body: { TransactionNumber: 1234 }.to_json)

          post :create, params: place_loan_form_params
        end

        it 'redirects to summaries' do
          expect(response).to redirect_to ill_result_path
        end

        it 'sets a Redis record containing success denoted by patron\'s key' do
          results = Redis.current.get 'place_loan_results_1234567'

          expect(JSON.parse(results).dig('result', 'success')).to be_present
        end
      end

      context 'when place loan fails' do
        before do
          stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Users/abc123")
            .with(headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
            .to_return(status: 200, body: {}.to_json)
          stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/")
            .with(body: request_body,
                  headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
            .to_return(status: 400, body: { TransactionNumber: 1234 }.to_json)

          post :create, params: place_loan_form_params
        end

        it 'redirects to summaries' do
          expect(response).to redirect_to ill_result_path
        end

        it 'sets a Redis record containing error denoted by patron\'s key' do
          results = Redis.current.get 'place_loan_results_1234567'

          error_msg = JSON.parse(results).dig('result', 'error', 'error_message')
          expect(error_msg).to eq 'Interlibrary Loan Request Failed'
        end
      end

      context 'when placing loan with missing params' do
        before do
          post :create, params: place_loan_form_params.except(:pickup_by_date)
        end

        it 'redirects to the new ill loan page' do
          expect(response).to redirect_to new_ill_path(catkey: 1)
        end

        it 'sets a flash error message' do
          expect(flash[:error]).to match(/choose a not needed after date/)
        end
      end
    end

    describe '#result' do
      context 'when redirected from /ill/new' do
        before do
          request.env['HTTP_REFERER'] = 'http://example.com/ill/new'

          Redis.current.set 'place_loan_results_1234567', { id: '12345678',
                                                            result: {
                                                              catkey: 1,
                                                              success: {}
                                                            } }.to_json
        end

        after do
          Redis.current.del 'place_loan_results_1234567'
        end

        it 'renders results' do
          get :result

          expect(response).to render_template 'result'
        end
      end

      context 'when not redirected from /ill/new' do
        before do
          request.env['HTTP_REFERER'] = 'http://example.com/other/path'

          Redis.current.set 'place_loan_results_1234567', { id: '12345678',
                                                            result: {
                                                              catkey: 1,
                                                              success: {}
                                                            } }.to_json
        end

        after do
          Redis.current.del 'place_loan_results_1234567'
        end

        it 'redirects to the not found page' do
          get :result

          expect(response).to redirect_to '/not_found'
        end
      end

      context 'when result not found in Redis' do
        it 'redirects to the not found page' do
          get :result

          expect(response).to redirect_to '/not_found'
        end
      end
    end
  end
end
