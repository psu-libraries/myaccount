# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Holds', type: :feature do
  # patron1 below has 1 hold ready for pick and 4 holds not yet ready for pickup
  let(:mock_user) { 'patron1' }

  before do
    login_as username: 'PATRON1', patron_key: mock_user
  end

  after do
    Redis.new.del 'item_type_map'
  end

  context 'when a patron has some holds not yet ready to pickup (i.e., pending)' do
    it 'lets the user change the pickup library of a hold', js: true do
      visit holds_path
      login_as username: 'PATRON1', patron_key: mock_user
      page.check 'hold_list__3911148'
      page.select 'Penn State York', from: 'pickup_library'
      page.click_button 'Update Selected Holds'
      expect(page).to have_css '#hold3911148 .pickup_at', text: 'York'
    end

    it 'lets the user change the pickup by date of a hold', js: true do
      visit holds_path
      login_as username: 'PATRON1', patron_key: mock_user
      page.check 'hold_list__3911148'
      page.fill_in 'pickup_by_date', with: '01-01-9999'
      page.click_button 'Update Selected Holds'
      expect(page).to have_css '#hold3911148 .pickup_by', text: 'January 1, 9999'
    end

    it 'lets the user cancel a pending hold', js: true do
      visit holds_path
      login_as username: 'PATRON1', patron_key: mock_user
      page.check 'hold_list__3911148'
      page.click_button 'Cancel'
      expect(page).to have_css '#hold3911148 .hold_status', text: 'Cancelled'
    end

    it 'lets the user cancel a ready for pickup hold', js: true do
      visit holds_path
      login_as username: 'PATRON1', patron_key: mock_user
      page.check 'hold_list__3906718'
      page.click_button 'Cancel Selected Holds'
      expect(page).to have_css '#hold3906718 .hold_status', text: 'Cancelled'
    end
  end

  context 'when a patron attempts to create a hold for a monograph', js: true do
    it 'renders a form for the item being requested' do
      visit '/holds/new?catkey=6066288'
      expect(page).to have_text 'Title: 13 bankers : the Wall Street takeover and the next financial meltdown'
    end
  end
end
