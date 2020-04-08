# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'holds/index.html.erb', type: :view do
  let(:hold) { build(:hold) }

  before do
    allow(hold).to receive(:item_type_mapping).and_return(ITEM_TYPE_MAPPING)
  end

  context 'when there are holds ready to pickup' do
    before do
      assign(:holds_ready, [hold])
    end

    it 'displays a hold' do
      hold.record['fields']['bib']['fields']['title'] = 'A wonderful title'
      render
      expect(rendered).to include 'A wonderful title'
    end

    describe 'holds page' do
      it 'has no holds that are not ready for pickup' do
        render
        expect(rendered).not_to include 'Holds that are not ready for pickup'
      end

      it 'has only holds ready for pickup' do
        render
        expect(rendered).to include 'Holds that are ready for pickup'
      end
    end
  end

  context 'when there are only holds not ready to pickup' do
    before do
      assign(:holds_not_ready, [hold])
    end

    describe 'holds page' do
      it 'has only holds not ready for pickup' do
        render
        expect(rendered).not_to include 'Holds that are ready for pickup'
      end

      it 'has only holds ready for pickup' do
        render
        expect(rendered).to include 'Holds that are not ready for pickup'
      end
    end
  end

  context 'when there are only no holds' do
    describe 'holds page' do
      it 'shows a message that there aren\'t holds' do
        render
        expect(rendered).to include 'You have no holds at this time'
      end
    end
  end
end
