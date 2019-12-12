# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'fines/index.html.erb' do
  context 'when a single fine exists' do
    let(:fine) { build(:fine) }

    before do
      assign(:fines, [fine])
    end

    it 'displays fine dollar amount correctly' do
      fine.record['fields']['owed']['amount'] = '100.00'
      render
      expect(rendered).to include '$100.00'
    end

    it 'displays fine\'s reason correctly' do
      fine.record['fields']['block']['key'] = 'DAMAGE'
      render
      expect(rendered).to include 'Fee for damaged materials'
    end

    it 'displays fine\'s item\'s title' do
      fine.record['fields']['item']['fields']['bib']['fields']['title'] = 'A wonderful title'
      render
      expect(rendered).to include 'A wonderful title'
    end

    it 'displays fine\'s item\'s author' do
      fine.record['fields']['item']['fields']['bib']['fields']['author'] = 'A wonderful author'
      render
      expect(rendered).to include 'A wonderful author'
    end

    it 'displays fine\'s item\'s canonical item link' do
      fine.record['fields']['item']['fields']['bib']['key'] = '123456'
      render
      expect(rendered).to include 'catalog.libraries.psu.edu/catalog/123456'
    end

    it 'displays fine\'s item\'s item type' do
      fine.record['fields']['item']['fields']['itemType']['key'] = 'PERIODICAL'
      render
      expect(rendered).to include 'Bound Journal'
    end

    it 'displays fine\'s bill date' do
      fine.record['fields']['billDate'] = '1999-12-31'
      render
      expect(rendered).to include 'December 31, 1999'
    end
  end
end
