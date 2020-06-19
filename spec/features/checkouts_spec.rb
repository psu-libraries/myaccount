# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkouts', type: :feature do
  # patron2 below has 2 checkouts
  let(:mock_user) { 'patron2' }

  before do
    login_as username: 'PATRON2', patron_key: mock_user
  end

  after do
    Redis.new.del 'item_type_map'
  end

  context 'when patron renews a checkout successfully' do
    it 'updates the renewal count, due date and status', js: true do
      visit checkouts_path
      login_as username: 'PATRON2', patron_key: mock_user
      page.check 'renewal_list__2145643:5:1'
      page.click_button 'Renew', match: :first
      expect(page).to have_css('[id="checkout2145643:5:1"] .renewal_count', text: '70')
        .and have_css('[id="checkout2145643:5:1"] .due_date', text: 'August 13, 2020')
        .and have_css '[id="checkout2145643:5:1"] .status', text: ''
    end
  end
end