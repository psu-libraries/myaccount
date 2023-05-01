# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  before do
    allow(controller).to receive(:controller_name).and_return('test')
  end

  describe '#nav_link_attributes' do
    context 'when the current page matches the active controller' do
      it 'produces user-friendly features indicating current location' do
        attributes = {
          aria: { current: 'page' },
          class: 'nav-link hover-change rounded-0 py-3 active'
        }
        expect(helper.nav_link_attributes('/test')).to eq attributes
      end
    end

    context 'when the current page does not match the active controller' do
      it 'produces user-friendly features indicating current location' do
        expect(helper.nav_link_attributes('/blah')).to eq({ aria: { current: nil }, class: 'nav-link hover-change ' \
                                                                                           'rounded-0 py-3' })
      end
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

  describe '#ill_manage_link' do
    context 'when passed a "library" argument of "HERSHEY"' do
      it 'returns the link to manage Illiad data for Hershey' do
        expect(helper.ill_manage_link('HERSHEY')).to eq Settings.illiad.manage_hershey_url
      end
    end

    context 'when passed a "library" argument of "UP-PAT"' do
      it 'returns the link to manage Illiad data for Hershey' do
        expect(helper.ill_manage_link('UP-PAT')).to eq Settings.illiad.manage_url
      end
    end
  end
end
