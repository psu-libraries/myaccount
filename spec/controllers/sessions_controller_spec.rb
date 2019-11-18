# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  let(:mock_client) { instance_double(SymphonyClient) }

  before do
    allow(SymphonyClient).to receive(:new).and_return(mock_client)
  end

  context 'with an authenticated request' do
    let(:user) do
      { username: 'zzz123', patron_key: 1234567 }
    end

    before do
      warden.set_user(user)
    end

    describe 'GET index' do
      it 'redirects to the home page' do
        expect(get(:index)).to redirect_to summaries_url
      end
    end

    describe 'GET destroy' do
      it 'logs out of the current session' do
        get :destroy

        expect(warden.user).to be_nil
      end

      it 'redirects to the root' do
        expect(get(:destroy)).to redirect_to root_url
      end
    end
  end
end
