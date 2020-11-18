# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Patron', type: :feature do
  let(:mock_user) { 'patron1' }

  before do
    login_permanently_as username: 'PATRON1', patron_key: mock_user
  end

  after do
    Warden::Manager._on_request.clear
  end

  describe 'the patron page', js: true do
    it 'is accessible' do
      visit patron_path 'foo'

      expect(page).to be_accessible
    end
  end
end
