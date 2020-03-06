# frozen_string_literal: true

# Responsible for building data needed to populate the place hold results.
class PlaceHoldResults::Builder
  def initialize(user_token:, client:, place_hold_results:)
    @user_token = user_token
    @client = client # SymphonyClient
    @place_hold_results = place_hold_results
  end

  def generate
    @place_hold_results.each do |status, results|
      if status == 'success'.to_sym
        results.map { |result| result[:placed_hold] = hold_lookup(result[:hold_key]) }
      else
        results.map { |result| result[:failed_hold] = item_lookup(result[:barcode]) }
      end
    end
  end

  private

    def hold_lookup(hold_key)
      parsed_hold = SymphonyClientParser::parsed_response(@client, :get_hold_info, hold_key, @user_token)

      start = DateTime.now
      while parsed_hold.dig('fields', 'item').nil? && start + 5.seconds > DateTime.now
        parsed_hold = SymphonyClientParser::parsed_response(@client, :get_hold_info, hold_key, @user_token)
      end

      Hold.new parsed_hold
    end

    def item_lookup(barcode)
      parsed_item = SymphonyClientParser::parsed_response(@client, :get_item_info, barcode, @user_token)
      Item.new parsed_item
    end
end
