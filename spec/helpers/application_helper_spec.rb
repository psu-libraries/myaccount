# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#derive_path' do
    it 'calls the Rails path method that returns a route' do
      expect(helper.derive_path('summaries')).to eq '/summaries'
    end
  end

  describe '#nav_link_attributes' do
    it 'produces user-friendly features indicating current location' do
      expect(helper.nav_link_attributes('test')).to eq({ aria: { current: 'page' }, class: 'nav-link hover-change'\
                                                            ' rounded-0 py-3 active-nav-link' })
    end
  end

  describe '#current_year' do
    let(:some_day) { Date.parse('21000203') }

    before do
      allow(Date).to receive(:today).and_return(some_day)
    end

    it 'returns the current year' do
      expect(helper.current_year).to eq 2100
    end
  end
end
