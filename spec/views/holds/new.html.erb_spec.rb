# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'holds/new.html.erb', type: :view do
  let(:bib) { build(:bib_with_holdables) }

  context 'with a new hold with holdables to choose' do
    before do
      assign(:bib, bib)
    end

    it 'sets the pickup by date to two months from now and adds a minimum value' do
      render
      expect(rendered).to include '<input type="date" name="pickup_by_date" id="pickup_by_date" value="2020-04-19"'\
                                  ' required="required" min="2020-02-19" />'
    end
  end
end
