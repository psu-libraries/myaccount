# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsController do
  let(:mock_patron) { instance_double(Patron, barcode: '123456789', library: 'UP-PAT', library_ill_path_key: 'upm') }

  before do
    allow(controller).to receive(:patron).and_return(mock_patron)
  end

  context 'with an unauthenticated request' do
    it 'redirects to the home page' do
      expect(get(:index)).to redirect_to root_url
    end
  end

  context 'with an authenticated request' do
    let(:user) do
      { username: 'zzz123',
        name: 'Zeke',
        patron_key: '1234567',
        session_token: 'e0b5e1a3e86a399112b9eb893daeacfd' }
    end

    let(:mock_patron) { instance_double(Patron, checkouts:, library: 'UP-PAT', library_ill_path_key: 'upm') }

    let(:checkouts) { [
      instance_double(Checkout, item_key: '123', resource: 'item', bib_summary: 'Renewal 1 (ABC)', due_date: nil),
      instance_double(Checkout, item_key: '456', resource: 'item', bib_summary: 'Renewal 2 (DEF)', due_date: nil),
      instance_double(Checkout, item_key: '789', resource: 'item', bib_summary: 'Renewal 3 (GHI)', due_date: nil)
    ] }

    let(:mock_client) do
      instance_double(SymphonyClient, ping?: true)
    end

    before do
      warden.set_user(user)
      allow(SymphonyClient).to receive(:new).and_return(mock_client)
      allow(mock_patron).to receive(:checkouts).and_return(checkouts)
    end

    describe '#index' do
      before do
        allow(ViewCheckoutsJob).to receive(:perform_later)
        allow(ViewIlliadLoansJob).to receive(:perform_later)
        stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
          .with(
            headers: {
              'Apikey' => '1234',
              'Connection' => 'close',
              'Content-Type' => 'application/json',
              'Host' => 'illiad.illiad',
              'User-Agent' => 'http.rb/4.4.1'
            }
          )
          .to_return(status: 200, body: '[]', headers: {})
      end

      it 'sends a job to ViewCheckoutsJob' do
        get :index

        expect(ViewCheckoutsJob).to have_received(:perform_later)
      end

      it 'sends a job to ViewIlliadLoansJob' do
        get :index

        expect(ViewIlliadLoansJob).to have_received(:perform_later)
      end

      it 'renders the index template' do
        get :index

        expect(response).to render_template 'index'
      end
    end

    describe '#batch_update' do
      before do
        allow(RenewCheckoutJob).to receive(:perform_later)
      end

      it 'sends a job to RenewalJob' do
        patch :batch_update, params: { renewal_list: ['123', '456'] }

        expect(RenewCheckoutJob).to have_received(:perform_later).twice
      end
    end

    describe '#export_ill_ris' do
      let(:return_body) do
        '[{"TransactionNumber":123456, "DocumentType":"Book", "LoanDate":"2016",
           "LoanAuthor":"Author1, Test", "LoanTitle":"The Book Title 1",
           "ISSN":"1234567890", "LoanPlace":null, "LoanEdition":"edition"},
          {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
            "LoanAuthor":"Author2, Test", "LoanTitle":"The Book Title 2", "LoanPublisher":null,
            "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"}]'
      end
      let(:expected_content_type) { 'application/x-research-info-systems' }
      let(:expected_file_name) { 'document.ris' }

      before do
        stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
          .with(
            headers: {
              'Apikey' => '1234',
              'Connection' => 'close',
              'Content-Type' => 'application/json',
              'Host' => 'illiad.illiad',
              'User-Agent' => 'http.rb/4.4.1'
            }
          )
          .to_return(status: 200, body: return_body, headers: {})
      end

      it 'exports ILL checkout data as an RIS file' do
        get :export_ill_ris

        expect(response.headers['Content-Disposition']).to include("attachment; filename=\"#{expected_file_name}\"")
        expect(response.headers['Content-Type']).to eq(expected_content_type)
        expect(response.body).to match(/TY  - BOOK/)
        expect(response.body).to match(/TI  - The Book Title 1/)
        expect(response.body).to match(/PY  - 2016/)
        expect(response.body).to match(/SN  - 1234567890/)
        expect(response.body).to match(/Y2/)
        expect(response.body).to match(/ET  - edition/)
        expect(response.body).to match(/TI  - The Book Title 2/)
      end
    end

    describe '#export_ill_checkouts_email' do
      let(:checkout_params) { [{
        title: 'Snow country',
        author: 'Kawabata, Yasunari, 1899-1972.',
        date: '2016',
        identifier: '1234567890'
      }]
      }
      let(:return_body) do
        '[{"TransactionNumber":123456, "DocumentType":"Book", "LoanDate": "2016",
        "LoanAuthor": "Kawabata, Yasunari, 1899-1972.", "LoanTitle": "Snow country",
           "ISSN": "1234567890"}]'
      end
      let(:mailer_double) { double 'ill_mailer', deliver_now: 'testing' }

      before do
        stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
          .with(
            headers: {
              'Apikey' => '1234',
              'Connection' => 'close',
              'Content-Type' => 'application/json',
              'Host' => 'illiad.illiad',
              'User-Agent' => 'http.rb/4.4.1'
            }
          )
          .to_return(status: 200, body: return_body, headers: {})
        allow(CheckoutsMailer).to receive(:export_ill_checkouts).with('zzz123', checkout_params)
          .and_return(mailer_double)
      end

      it 'calls the ILL checkouts mailer to export ILL checkouts' do
        get :export_ill_checkouts_email

        expect(mailer_double).to have_received(:deliver_now)
      end

      it 'displays a success flash message' do
        get :export_ill_checkouts_email

        expect(flash[:success]).to eq I18n.t('myaccount.email.success')
      end

      context 'when the email is not successful' do
        before do
          allow(CheckoutsMailer).to receive(:export_ill_checkouts).with('zzz123', checkout_params)
            .and_raise(StandardError.new('Test error message'))
        end

        it 'displays an error flash message' do
          get :export_ill_checkouts_email

          expect(flash[:error]).to eq I18n.t('myaccount.email.error')
        end
      end
    end

    describe '#export_checkouts_email' do
      let(:checkout_params) { [{
        title: 'Becoming',
        author: 'Obama, Michelle, 1964- author.',
        catkey: '24053587',
        call_number: 'E909.O24A3 2018'
      }] }
      let(:mailer_double) { double 'mailer', deliver_now: 'test' }

      before do
        allow(CheckoutsMailer).to receive(:export_checkouts).with('zzz123', checkout_params)
          .and_return(mailer_double)
      end

      it 'calls the checkouts mailer to export checkouts' do
        get :export_checkouts_email, params: { checkouts: checkout_params }

        expect(mailer_double).to have_received(:deliver_now)
      end

      it 'displays a success flash message' do
        get :export_checkouts_email, params: { checkouts: checkout_params }

        expect(flash[:success]).to eq I18n.t('myaccount.email.success')
      end

      context 'when the email is not successfully sent' do
        before do
          allow(CheckoutsMailer).to receive(:export_checkouts).with('zzz123', checkout_params)
            .and_raise(StandardError.new('Test error message'))
        end

        it 'displays an error flash message' do
          get :export_checkouts_email, params: { checkouts: checkout_params }

          expect(flash[:error]).to eq I18n.t('myaccount.email.error')
        end
      end
    end
  end
end
