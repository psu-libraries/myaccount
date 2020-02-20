# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'holds/new.html.erb', type: :view do
  let(:bib) { build(:bib_with_holdables) }

  context 'with a new hold with holdables to choose' do
    before do
      assign(:bib, bib)
    end

    xit 'sets the pickup by date to two months from now' do
    end
  end
end
