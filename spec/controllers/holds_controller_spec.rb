# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HoldsController, type: :controller do
  let(:mock_patron) { instance_double(Patron) }
  let(:holds) do
    [
      instance_double(Hold, key: 1, ready_for_pickup?: true, title: 'Some Great Book'),
      instance_double(Hold, key: 2, ready_for_pickup?: false, title: 'Some Good Book')
    ]
  end

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
      get :index
      expect(response).to render_template 'index'
    end

    it 'assigns holds ready for pickup' do
      get :index

      expect(assigns(:holds_ready).count).to eq 1
    end

    it 'assigns holds not ready for pickup' do
      get :index

      expect(assigns(:holds_not_ready).count).to eq 1
    end

    describe '#destroy' do
      before do
        stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/cancelHold')
          .to_return(status: 200, body: '', headers: {})
      end

      context 'when everything is good' do
        it 'a delete is attempted and succeeds' do
          delete :destroy, params: { id: 'multiple', hold_list: [2] }

          expect(flash[:success]).to match(/Some Good Book/)
        end
      end

      context 'when the web service does not respond with a 200' do
        before do
          stub_request(:post, 'https://example.com/symwsbc/circulation/holdRecord/cancelHold')
            .to_return(status: 400, body: 'A bad thing', headers: {})
        end

        it 'deletes holds and fails' do
          delete :destroy, params: { id: 'multiple', hold_list: [2] }

          expect(flash[:errors]).to match(/Sorry!/)
        end
      end
    end
  end
end
