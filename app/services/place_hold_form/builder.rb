# frozen_string_literal: true

# Responsible for building data needed to populate the place hold form.
class PlaceHoldForm::Builder
  def initialize(catkey:, user_token:, client:)
    @catkey = catkey
    @user_token = user_token
    @client = client # SymphonyClient
    @volumetric_calls = []
  end

  def generate
    bib_info = Bib.new(parsed_symphony_response(:get_bib_info, @catkey, @user_token))
    @call_list = bib_info.call_list.map { |c| Call.new record: c }
    process_volumetric_calls

    {
      catkey: @catkey,
      title: bib_info.title,
      author: bib_info.author,
      volumetric_calls: @volumetric_calls,
      barcode: @volumetric_calls.present? ? nil : @call_list.sample.items.sample.barcode
    }
  end

  private

    def parsed_symphony_response(symphony_call, *params)
      client_response = @client.send(symphony_call, *params)
      JSON.parse client_response.body
    end

    # Take the @call_list (Array of Calls) and check for volumetrics and process if present.
    #
    # First: find out what Items are holdable inside Calls. Order is important.
    #
    #  * Must be more than 1 overall potential holdable Call.
    #  * Each potential holdable must have a current location that is holdable.
    #  * To be a holdable set:
    #    * Must be at least one volumetric Call.
    #    * Must be more than one Call with items that are holdable.
    #
    # In the case where a holdable set is not discovered, the @volumetric_calls instance variable remains empty and a
    # barcode from a random item in a random call in the @call_list is used (local logic in Symphony dictates).
    #
    # Second: sort naturally by Call#volumetric.
    #
    # Third: If there happen to be non-voluemtrics along-side the volumetrics, reduce them to just 1.
    #
    # Fourth: Only pass along the volumetric calls that have unique Call#call_number
    def process_volumetric_calls
      filter_holdables if @call_list.count > 1
      @volumetric_calls = @call_list.dup if volumetric? && @call_list.count > 1
      volumetric_natural_sort
      compact_non_volumetric_calls if @volumetric_calls.select { |c| c.volumetric.nil? }.count > 1
      @volumetric_calls.uniq!(&:call_number)
    end

    def compact_non_volumetric_calls
      process_these = @volumetric_calls.dup
      @volumetric_calls = []
      process_these.each_with_index do |c, i|
        @volumetric_calls << c unless i != 0 && c.volumetric.nil?
      end
    end

    def filter_holdables
      holdable_locations = find_holdable_locations

      @call_list.filter! do |c|
        current_locations = c.items.map(&:current_location)
        current_locations.filter { |loc| holdable_locations.include? loc }.present?
      end
    end

    def find_holdable_locations
      all_locations = parsed_symphony_response(:get_all_locations)
      all_locations.filter { |p| p&.dig 'fields', 'holdable' }
        .map { |p| p&.dig 'key' }
    end

    def volumetric_natural_sort
      @volumetric_calls.each { |i| i.record['naturalized_volumetric'] = naturalize(i.volumetric.to_s) }
        .sort_by! { |i| i.record['naturalized_volumetric'] }
    end

    # Replace periods with spaces and then transform string into an array of "naturalized" values.
    # E.g., `"v.2 1956"` becomes  `["v ", 2.0, 1956.0]`
    #
    # Regex translation:
    # `scan` looks for either any non-whitespace character or digit OR any digit. This keeps non-digit
    # characters that aren't whitespace and digits to prep the sort. After that collect the array to
    # cast strings containing digits to Float (leave non-digits alone).
    def naturalize(value)
      value.gsub(/\./, ' ')
        .scan(/[^\s\d]+|\d+/)
        .map { |f| /\d+/.match?(f) ? f.to_f : f }
    end

    def volumetric?
      @call_list&.any? { |i| i.volumetric.present? }
    end
end
