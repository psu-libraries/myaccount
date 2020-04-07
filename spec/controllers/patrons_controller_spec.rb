# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PatronsController do
  context 'with an unauthenticated request' do
    it 'redirects to the home page' do
      expect(get(:show, params: { id: 'idhere' })).to redirect_to root_url
    end
  end

  context 'with an authenticated request' do
    let(:user) {
      { username: 'zzz123',
        name: 'Zeke',
        patron_key: 'patron1',
        session_token: 'e0b5e1a3e86a399112b9eb893daeacfd' }
    }

    before do
      warden.set_user(user)
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: 'idhere' }

        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: 'idhere' }

        expect(response).to be_successful
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) { { 'first_name' => 'JOHN', 'middle_name' => 'ADAM', 'last_name' => 'DOE',
                                 'suffix' => 'SR', 'email' => 'zzz123@psu.edu', 'street1' => '123 Fake Street',
                                 'street2' => '', 'city' => 'Jersey Shore', 'state' => 'KY', 'zip' => '00000',
                                 'id' => 'idhere' } }

        it 'redirects to the patron' do
          put :update, params: new_attributes

          expect(response).to redirect_to(patron_path)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          # Missing required parameter last_name
          put :update, params: { 'first_name' => 'JOHN', 'middle_name' => 'ADAM', 'last_name' => '', 'suffix' => 'SR',
                                 'email' => 'zzz123@psu.edu', 'street1' => '123 Fake Street', 'street2' => '',
                                 'city' => 'Jersey Shore', 'state' => 'KY', 'zip' => '00000', 'id' => 'idhere' }

          expect(response).to redirect_to(edit_patron_path)
        end
      end
    end
  end
end
