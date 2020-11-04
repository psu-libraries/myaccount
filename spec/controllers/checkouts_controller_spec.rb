# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsController do
  let(:mock_patron) { instance_double(Patron, barcode: '123456789', library: 'UP_PAT') }

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

    let(:mock_patron) { instance_double(Patron, checkouts: checkouts) }

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
      it 'renders the index template' do
        get :index

        expect(response).to render_template 'index'
      end
    end

    describe '#all' do
      context 'when the Patron is valid' do
        before do
          allow(mock_patron).to receive(:valid?).and_return(true)
        end

        it 'redirects to 500 response' do
          get :all

          expect(response).to render_template 'all'
        end
      end

      context 'when the Patron is not valid' do
        before do
          allow(mock_patron).to receive(:valid?).and_return(false)
        end

        it 'redirects to 500 response' do
          get :all

          expect(response).to redirect_to('/500')
        end
      end
    end

    describe '#batch_update' do
      before do
        allow(RenewCheckoutJob).to receive(:perform_later)
      end

      it 'requires list of checkouts to be renewed as params' do
        patch :batch_update, params: {}

        expect(flash[:notice]).to match(/No items were selected/)
      end

      it 'sends a job to RenewalJob' do
        patch :batch_update, params: { renewal_list: ['123', '456'] }

        expect(RenewCheckoutJob).to have_received(:perform_later).twice
      end

      context 'when the requested item is not checked out to the patron' do
        it 'does not renew the item and sets flash messages' do
          post :batch_update, params: { renewal_list: ['some_made_up_checkout'] }

          expect(flash[:error]).to match('An unexpected error has occurred')
        end
      end
    end
  end
end
