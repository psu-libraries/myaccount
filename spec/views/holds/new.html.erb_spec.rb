# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'holds/new.html.erb', type: :view do
  let(:bib) { build(:bib_with_holdables) }

  context 'with a new hold with holdables to choose' do
    before do
      assign(:bib, bib)
    end

    it 'renders an checkbox inputs for each item' do
      render

      expect(rendered).to have_css('input[type="checkbox"]', count: 8)
    end

    it 'provides a way to Cancel and go back to the catalog' do
      render

      expect(rednered).to include 'f'
    end
  end
end
