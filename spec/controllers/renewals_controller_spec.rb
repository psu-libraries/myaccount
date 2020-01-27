# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RenewalsController do
  let(:user) do
    { username: 'zzz123',
      name: 'Zeke',
      patron_key: '1234567',
      session_token: 'e0b5e1a3e86a399112b9eb893daeacfd' }
  end

  let(:mock_patron) { instance_double(Patron, checkouts: checkouts) }
  let(:checkouts) { [
    instance_double(Checkout, item_key: '123', bib_summary: 'Renewal 1 (ABC)'),
    instance_double(Checkout, item_key: '456', bib_summary: 'Renewal 2 (DEF)'),
    instance_double(Checkout, item_key: '789', bib_summary: 'Renewal 3 (GHI)')
  ] }

  let(:renew_items_response) {}

  let(:mock_client) do
    instance_double(SymphonyClient, renew_items: renew_items_response)
  end

  before do
    warden.set_user(user)
    allow(SymphonyClient).to receive(:new).and_return(mock_client)
    allow(controller).to receive(:patron).and_return(mock_patron)
    stub_const('RenewalsController::RENEWAL_FLASH_LIMIT', 2)
  end

  it 'sends the right item details to the web service' do
    item_details = controller.send(:item_details)

    expect(item_details).to eq circRecordList: true
  end

  describe '#create' do
    it 'requires list of checkouts to be renewed as params' do
      post :create, params: {}

      expect(flash[:notice]).to match(/No items were selected/)
    end

    context 'when all items returns 200' do
      let(:renew_items_response) { { success: [checkouts[0], checkouts[1]], error: [] } }

      it 'renews the items and sets flash messages' do
        post :create, params: { renewal_list: ['123', '456'] }

        expect(flash[:success]).to match(/Success!/)
      end

      it 'renews the items and redirects to checkouts_path' do
        post :create, params: { renewal_list: ['123', '456'] }

        expect(response).to redirect_to checkouts_path
      end
    end

    context 'when not all items return 200' do
      let(:non_renewal_reason) { 'Item has holds' }
      let(:error_response) { { renewal: checkouts[2], error_message: non_renewal_reason } }
      let(:renew_items_response) { { success: [checkouts[0]], error: [error_response] } }

      it 'renews the eligible items and sets flash messages' do
        post :create, params: { renewal_list: ['123', '789'] }

        expect(flash[:success]).to match(/Success!/)
      end

      it 'success messages include items title' do
        post :create, params: { renewal_list: ['123', '789'] }

        expect(flash[:success]).to match(/Renewal 1/)
      end

      it 'does not renew those items and sets flash messages' do
        post :create, params: { renewal_list: ['123', '789'] }

        expect(flash[:error]).to match(/Sorry!/)
      end

      it 'error messages include items title and non renewal reason' do
        post :create, params: { renewal_list: ['123', '789'] }

        expect(flash[:error]).to match(/Renewal 3.*Item has holds/)
      end

      it 'does not renew those items and redirects to checkouts_path' do
        post :create, params: { renewal_list: ['123', '789'] }

        expect(response).to redirect_to checkouts_path
      end
    end

    context 'when response include errored items with empty error message' do
      let(:error_response) { { renewal: checkouts[2], error_message: '' } }
      let(:renew_items_response) { { success: [checkouts[0]], error: [error_response] } }

      it 'error messages include items title only if non renewal reason empty' do
        post :create, params: { renewal_list: ['123', '789'] }

        expect(flash[:error]).not_to match(/Denied/)
      end
    end

    context 'when user renews more than renewal flash limit items' do
      let(:non_renewal_reason) { 'Item has holds' }
      let(:error_response) { { renewal: checkouts[2], error_message: non_renewal_reason } }
      let(:renew_items_response) {
        { success: [checkouts[0], [checkouts[1]]], error: [error_response] }
      }

      it 'renews the eligible items and sets flash messages' do
        post :create, params: { renewal_list: ['123', '456', '789'] }

        expect(flash[:success]).to match(/Success!/)
      end

      it 'success messages does not include items title' do
        post :create, params: { renewal_list: ['123', '456', '789'] }

        expect(flash[:success]).not_to match(/Renewal 1/)
      end

      it 'does not renew those items and sets flash messages' do
        post :create, params: { renewal_list: ['123', '456', '789'] }

        expect(flash[:error]).to match(/Sorry!/)
      end

      it 'error messages does not include items title and non renewal reason' do
        post :create, params: { renewal_list: ['123', '456', '789'] }

        expect(flash[:error]).not_to match(/Renewal 3.*Item has holds/)
      end

      it 'redirects to checkouts_path' do
        post :create, params: { renewal_list: ['123', '456', '789'] }

        expect(response).to redirect_to checkouts_path
      end
    end

    context 'when the requested item is not checked out to the patron' do
      it 'does not renew the item and sets flash messages' do
        post :create, params: { renewal_list: ['some_made_up_checkout'] }

        expect(flash[:error]).to match('An unexpected error has occurred')
      end

      it 'does not renew the item and redirects to checkouts_path' do
        post :create, params: { renewal_list: ['some_made_up_checkout'] }

        expect(response).to redirect_to checkouts_path
      end
    end
  end
end
