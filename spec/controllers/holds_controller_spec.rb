# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HoldsController, type: :controller do
  let(:mock_patron) { instance_double(Patron) }
  let(:holds) {
    [
      instance_double(Hold, ready_for_pickup?: true),
      instance_double(Hold, ready_for_pickup?: false)
    ]
  }

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

    it 'renders the index template' do
      get(:index)
      expect(response).to render_template 'index'
    end

    it 'assigns holds ready for pickup' do
      get(:index)

      expect(assigns(:holds_ready).count).to eq 1
    end

    it 'assigns holds not ready for pickup' do
      get(:index)

      expect(assigns(:holds_not_ready).count).to eq 1
    end
  end
end
