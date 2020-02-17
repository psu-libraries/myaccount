# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'holds/new.html.erb', type: :view do
  let(:bib) { build(:bib_with_holdables) }

  context 'with a new hold with holdables to choose' do
    before do
      assign(:bib, bib)
    end

    it 'sets the pickup by date to two months from now' do
      render
      expect(rendered).to include '<input value="2020-04-17" type="date" name="hold[pickup_by_date]"'\
                                  ' id="hold_pickup_by_date" />'
    end
  end
end
