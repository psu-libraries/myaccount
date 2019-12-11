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

    let(:checkouts) { [instance_double(Checkout, key: '1', due_date: nil)] }

    before do
      warden.set_user(user)
      allow(mock_patron).to receive(:checkouts).and_return(checkouts)
    end

    it 'renders the index template' do
      get(:index)
      expect(response).to render_template 'index'
    end

    it 'assigns a list of fines' do
      get(:index)

      expect(assigns(:checkouts)).to eq checkouts
    end
  end
end