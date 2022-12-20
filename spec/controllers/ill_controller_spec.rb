# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IllController, type: :controller do
  let(:mock_patron) { instance_double(Patron, barcode: '12345678', library: 'UP_PAT', ill_ineligible?: ill_ineligible) }
  let(:bib) { instance_double(Bib, title: 'Some Great Book', author: 'Great Author') }
  let(:ill_ineligible) { false }

  before do
    allow(controller).to receive(:patron).and_return(mock_patron)
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
      form_params = {
        catkey: '1',
        title: 'Some Great Book',
        author: 'Great Author'
      }

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
                                              isbn: '1234567') }

      let(:mock_illiad_client) { instance_double(IlliadClient) }
      let(:place_loan_response) { { message: ['Loan Placed Successufly'] } }

      before do
        allow(IllTransaction).to receive(:new).and_return(ill_transaction)
        allow(IlliadClient).to receive(:new).and_return(mock_illiad_client)
        allow(mock_illiad_client).to receive(:place_loan).and_return(place_loan_response)
      end

      context 'when provided needed params' do
        before do
          post :create, params: place_loan_form_params
        end

        it 'redirects to summaries' do
          expect(response).to redirect_to summaries_path
        end

        it 'sets a flash message' do
          expect(flash[:alert]).to eq 'Loan Placed Successufly'
        end
      end

      context 'when placing loan with missing pickup by date' do
        before do
          post :create, params: place_loan_form_params.except(:pickup_by_date)
        end

        it 'redirects to the new ill loan page' do
          expect(response).to redirect_to new_ill_path(catkey: '1')
        end

        it 'sets a flash error message' do
          expect(flash[:error]).to eq I18n.t 'myaccount.hold.place_hold.select_date'
        end
      end
    end
  end
end
