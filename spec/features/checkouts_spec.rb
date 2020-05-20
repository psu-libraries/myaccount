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

  context 'when patron has checkouts to display', js: true do
    before do
      visit checkouts_path
      login_as username: 'PATRON2', patron_key: mock_user
    end

    it 'displays total checked out correctly' do
      expect(page).to have_content 'Total Checked Out: 2'
    end

    it 'displays total # of recalled items correctly' do
      expect(page).to have_content 'Recalled: 1'
    end

    it 'displays total # of overdue items correctly' do
      expect(page).to have_content 'Overdue: 2'
    end

    it 'displays checkout\'s item\'s title / author' do
      expect(page).to have_content 'The labor situation in the Las Mercedes free'\
                              ' trade zone in Managua, Nicaragua / Levit, Alex C.'
    end

    it 'displays call number correctly' do
      expect(page).to have_content 'HD8110.5.C667 2007'
    end

    it 'displays checkout\'s item\'s canonical item link' do
      expect(page).to have_link('The politics of labor reform in Latin America : between flexibility and rights'\
                    ' / Cook, Maria Lorena.', href: 'https://catalog.libraries.psu.edu/catalog/3591032')
    end

    it 'displays checkout\'s item\'s item type' do
      expect(page).to have_content 'Penn State Thesis (Bachelors)'
    end

    it 'displays checkout\'s renewal count' do
      expect(page).to have_css('[id="checkout2145643:5:1"] .renewal_count', text: '69')
    end

    it 'displays checkout\'s due date correctly when not recalled' do
      expect(page).to have_css('[id="checkout2145643:5:1"] .due_date', text: 'May 7, 2020')
    end

    it 'displays checkout\'s estimated overdue amount when item is overdue' do
      expect(page).to have_content '$10.00'
    end

    it 'displays checkout\'s due date correctly when recalled' do
      expect(page).to have_css('[id="checkout3591032:1:1"] .due_date',
                               text: 'Recalled<br>August 4, 2020 10:34am<br>May 7, 2020')
    end

    it 'displays checkout\'s status correctly when overdue' do
      expect(page).to have_css('[id="checkout2145643:5:1"] .status', text: 'Overdue')
    end

    it 'displays checkout\'s status correctly when claims returned' do
      expect(page).to have_css('[id="checkout3591032:1:1"] .status', text: 'Claims Returned')
    end

    it 'displays a renew all select' do
      expect(page).to have_unchecked_field 'renewal_list__2145643:5:1'
    end

    it 'displays a renew button' do
      expect(page).to have_button 'Renew'
    end
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
