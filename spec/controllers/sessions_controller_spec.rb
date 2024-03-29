# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  context 'with an authenticated request' do
    let(:mock_client) { instance_double(SymphonyClient) }
    let(:user) do
      { username: 'zzz123', patron_key: 1234567 }
    end

    before do
      allow(SymphonyClient).to receive(:new).and_return(mock_client)
      warden.set_user(user)
    end

    describe 'GET index' do
      it 'redirects to the home page' do
        expect(get(:index)).to redirect_to summaries_url
      end

      context 'when user requested a page before authentication' do
        before do
          session[:original_fullpath] = '/holds/new?catkey=12345'
        end

        it 'redirects to the original request url' do
          expect(get(:index)).to redirect_to '/holds/new?catkey=12345'
        end
      end
    end

    describe 'GET destroy' do
      it 'logs out of the current session' do
        get :destroy

        expect(warden.user).to be_nil
      end

      it 'redirects to the root' do
        expect(get(:destroy)).to render_template 'destroy'
      end
    end
  end

  context 'with an unauthenticated request due to no user in Symphony' do
    before do
      allow(SymphonyClient).to receive(:new).and_return(nil)
      allow(controller).to receive(:authenticate_webaccess).and_return(nil)
    end

    it 'redirects to the user not found page' do
      expect(get(:index)).to redirect_to '/user_not_found'
    end
  end
end
