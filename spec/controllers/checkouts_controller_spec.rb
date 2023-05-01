# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsController do
  let(:mock_patron) { instance_double(Patron, barcode: '123456789', library: 'UP-PAT') }

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

    let(:mock_patron) { instance_double(Patron, checkouts:, library: 'UP-PAT') }

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
  end
end
