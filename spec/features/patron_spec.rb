# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Patron', type: :feature do
  let(:mock_user) { 'patron1' }

  before do
    login_permanently_as username: 'PATRON1', patron_key: mock_user
  end

  it 'is accessible', js: true do
    visit patron_path 'foo'

    expect(page).to be_accessible
  end
end
