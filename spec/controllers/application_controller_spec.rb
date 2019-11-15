require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:mock_client) { instance_double(SymphonyClient) }

  let(:user) do
    { username: 'zzz123',
      name: 'Zeke',
      patron_key: '1234567',
      session_token: 'e0b5e1a3e86a399112b9eb893daeacfd' }
  end

  before do
    allow(SymphonyClient).to receive(:new).and_return(mock_client)
  end

  describe '#current_user' do
    before do
      warden.set_user(user)
    end

    it 'returns the warden user' do
      expect(controller.current_user).to have_attributes username: 'zzz123',
                                                         name: 'Zeke',
                                                         patron_key: '1234567',
                                                         session_token: 'e0b5e1a3e86a399112b9eb893daeacfd'
    end
  end

  describe '#current_user?' do
    context 'with a logged in user' do
      before do
        warden.set_user(user)
      end

      it 'is true' do
        expect(controller.current_user?).to be true
      end
    end

    context 'without a logged in user' do
      it 'is false' do
        expect(controller.current_user?).to be false
      end
    end
  end

  describe '#patron' do

  end
end
