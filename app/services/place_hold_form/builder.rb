
# Responsible for building data needed to populate the place hold form.
class PlaceHoldForm::Builder

  def initialize(catkey:, user_token:, client:)
    @catkey = catkey
    @user_token = user_token
    @client = client #SymphonyClient
  end

  def generate
    bib_info = Bib.new(parsed_symphony_response(symphony_call: :get_bib_info))
    @call_list = bib_info.call_list.map { |c| Call.new record: c }
    @holdable_locations = parse_holdable_locations
    process_catalog_items

    {
        catkey: @catkey,
        title: bib_info.title,
        author: bib_info.author,
        call_list: @call_list,
        barcode: @call_list.present? ? nil : @call_list.sample.barcode
    }
  end

  private

  def parsed_symphony_response(symphony_call:)
    client_response = @client.send(symphony_call, @catkey, @user_token)
    JSON.parse client_response.body
  end

  # Take the array of Items and process based on local logic.
  #
  # First: find out what Items are holdable. Order is important.
  #
  #  * Must be more than 1 overall potential holdables (potential holdables are items in the call list).
  #  * Each potential holdable must have a current location that is holdable.
  #  * To be a holdable set:
  #    * Must be at least one volumetric holdable.
  #    * Must be more than one holdables.
  #
  # In the case where a holdable set is not discovered, nil is returned and the barcode instance attribute
  # is available to process the hold request.
  #
  # Second: sort naturally by volumetric attribute on Item.
  def process_catalog_items
    return nil unless @call_list.count > 1

    filter_holdables

    return nil unless volumetric? && @call_list.count > 1

    volumetric_natural_sort
  end

  def parse_holdable_locations
    result = @client.retrieve_holdable_locations.body
    parsed_body = JSON.parse result
    parsed_body.filter { |p| p&.dig 'fields', 'holdable' }
        .map { |p| p&.dig 'key' }
  end

  def filter_holdables
    @call_list.filter! do |c|
      current_locations = c.items.map { |i| i.current_location }
      current_locations.filter {|loc| @holdable_locations.include? loc }.present?
    end
  end

  def volumetric_natural_sort
    @call_list.each { |i| i.record['naturalized_volumetric'] = naturalize(i.volumetric.to_s) }
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
    @call_list&.find { |i| i.volumetric.present? }
  end

end
