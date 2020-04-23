# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Holds', type: :feature do
  let(:mock_user) { 'patron1' }

  before do
    login_as(username: 'PATRON1', patron_key: mock_user)
  end

  after do
    Redis.new.del('item_type_map')
  end

  it 'lets the user change the pickup library of a hold', js: true do
    visit holds_path
    login_as(username: 'PATRON1', patron_key: mock_user)
    page.check('hold_list__3911148')
    page.select 'Penn State York', from: 'pickup_library'
    page.click_button('Update Selected Holds')
    expect(page).to have_css '#hold3911148 .pickup_at', text: 'York'
  end
end
