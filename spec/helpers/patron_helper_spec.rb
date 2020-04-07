# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PatronHelper, type: :helper do
  describe '#us_states' do
    it 'contains a simple dictionary of US States and their abbreviations' do
      expect(helper.us_states['Arizona']).to eq 'AZ'
    end
  end
end
