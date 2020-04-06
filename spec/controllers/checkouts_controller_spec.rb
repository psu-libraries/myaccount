# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsController do
  let(:mock_patron) { instance_double(Patron) }

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
        patron_key: '1234567' }
    end

    let(:auth_response) { instance_double(HTTP::Response, status: 200) }

    let(:mock_client) do
      instance_double(SymphonyClient, authenticate: auth_response)
    end

    let(:checkouts) { [instance_double(Checkout, key: '1', due_date: nil)] }

    before do
      warden.set_user(user)
      allow(SymphonyClient).to receive(:new).and_return(mock_client)
      allow(mock_patron).to receive(:checkouts).and_return(checkouts)
    end

    it 'sends the right item details to the web service' do
      item_details = controller.send(:item_details)

      expect(item_details).to eq circRecordList: true
    end

    it 'renders the index template' do
      get(:index)

      expect(response).to render_template 'index'
    end

    it 'assigns a list of checkouts' do
      get(:index)

      expect(assigns(:checkouts)).to eq checkouts
    end
  end
end
