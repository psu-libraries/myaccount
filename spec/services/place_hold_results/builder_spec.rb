# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldResults::Builder do
  subject(:builder) { described_class.new(user_token: user_token, client: symphony_client,
                                          place_hold_results: place_hold_results) }

  let(:processed_results) { builder.generate }
  let(:user_token) { '2asf' }
  let(:symphony_client) { instance_double(SymphonyClient) }
  let(:hold_info_params) { ['a_hold_key', user_token] }
  let(:item_info_params) { ['not_holdable_barcode', user_token] }
  let(:parsed_hold_info) { JSON.parse HOLD_LOOKUP_RAW_JSON.to_json }
  let(:parsed_item_info) { JSON.parse ITEM_LOOKUP_RAW_JSON.to_json }
  let(:place_hold_results) { {
    success: [{ barcode: 'holdable_barcode', hold_key: 'a_hold_key' }],
    error: [{ barcode: 'not_holdable_barcode', error_message: 'User already has a hold on this material' }]
  }.with_indifferent_access }

  before do
    allow(SymphonyClientParser).to receive(:parsed_response).with(symphony_client, :get_hold_info, *hold_info_params)
      .and_return(parsed_hold_info)
    allow(SymphonyClientParser).to receive(:parsed_response).with(symphony_client, :get_item_info, *item_info_params)
      .and_return(parsed_item_info)
  end

  describe '#generate' do
    it 'will pass along processed placed holds results' do
      expect(processed_results[:success].first).to include(hold_key: 'a_hold_key')
        .and include(barcode: 'holdable_barcode')
        .and include(:placed_hold)
    end

    it 'returns Hold objects for placed holds' do
      expect(processed_results[:success].first[:placed_hold]).to be_a Hold
    end

    it 'returns correct Hold for each success' do
      expect(processed_results[:success].first[:placed_hold].key).to eq 'a_hold_key'
    end

    it 'will pass along processed failed holds results' do
      expect(processed_results[:error].first).to include(barcode: 'not_holdable_barcode')
        .and include(error_message: 'User already has a hold on this material')
        .and include(:failed_hold)
    end

    it 'returns Item objects for failed holds' do
      expect(processed_results[:error].first[:failed_hold]).to be_a Item
    end

    it 'returns correct Item for each error' do
      expect(processed_results[:error].first[:failed_hold].barcode).to eq 'not_holdable_barcode'
    end
  end
end
