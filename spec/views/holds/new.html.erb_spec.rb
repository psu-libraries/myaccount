# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'holds/new.html.erb', type: :view do
  let(:bib) { build(:bib_with_holdables) }

  context 'with a new hold with holdables to choose' do
    before do
      assign(:bib, bib)
    end

    it 'renders an input with a unique id attribute by barcode' do
      render

      expect(rendered).to have_css('input[type="checkbox"]', count: 8)
    end
  end
end
