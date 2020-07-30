# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkouts', type: :feature do
  # patron2 below has 2 checkouts
  let(:mock_user) { 'patron2' }

  before do
    login_permanently_as username: 'PATRON2', patron_key: mock_user
  end

  after do
    Redis.current.flushall
  end

  context 'when patron renews a checkout successfully' do
    it 'updates the renewal count, due date and status', js: true do
      visit checkouts_path
      page.check 'renewal_list__2145643:5:1'
      page.click_button 'Renew', match: :first
      expect(page).to have_css('[id="checkout2145643:5:1"] .renewal_count', text: '70')
        .and have_css('[id="checkout2145643:5:1"] .due-date', text: 'August 13, 2020')
        .and have_css '[id="checkout2145643:5:1"] .status', text: ''
    end
  end

  context 'when patron fails to renew a checkout successfully' do
    it 'generates an error message (a "toast")', js: true do
      visit checkouts_path
      page.check 'renewal_list__3591032:1:1'
      page.click_button 'Renew', match: :first
      expect(page).to have_css('.toast')
    end
  end
end
