# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SummariesController do
  let(:mock_client) { instance_double(SymphonyClient) }
  let(:mock_app_controller) { instance_double(ApplicationController) }

  before do
    allow(SymphonyClient).to receive(:new).and_return(mock_client)
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

    let(:mock_response) do
      {
        fields: {
          circRecordList: [{ key: 1 }]
        }
      }.with_indifferent_access
    end

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(mock_client).to receive(:patron_info).with(user, item_details: {}).and_return(mock_response)
      # allow(mock_app_controller).to receive(:current_user).and_return(user)
      warden.set_user(user)
    end

    it 'redirects to the home page' do
      expect(get(:index)).to render_template 'index'
    end
  end
end
