

class PlaceHoldForm::Builder

  def self.call(catkey:, user_token:, client:)
    client_response = client.get_bib_info catkey, user_token
    bib_info = Bib.new(record: JSON.parse(client_response.body))
    calls = bib_info.call_list.map { |c| Call.new record: c }

    holdable_locations = parse_holdable_locations client
    requestables = prepare_holdables calls: calls, holdable_locations: holdable_locations
    barcode = requestables.present? ? nil : items.sample.barcode

    {
      title: bib_info.title,
      author: bib_info.author,
      barcode: barcode,
      items: requestables
    }
  end

  private

  # Take the array of holds and find out what is holdable. Order is important.
  #
  #  * Must be more than 1 overall potential holdables (potential holdables are items in the call list).
  #  * Each potential holdable must have a current location that is holdable.
  #  * To be a holdable set:
  #    * Must be at least one volumetric holdable.
  #    * Must be more than one holdables.
  #
  # In the case where a holdable set is not discovered, nil is returned and the barcode instance attribute
  # is available to process the hold request.
  def self.prepare_holdables(calls: nil, holdable_locations: nil)
    return nil unless calls.count > 1

    calls = filter_holdables calls: calls, holdable_locations: holdable_locations

    return nil unless volumetric?(calls: calls) && calls.count > 1

    volumetric_natural_sort calls: calls
  end

  def self.parse_holdable_locations(client)
    result = client.retrieve_holdable_locations.body
    parsed_body = JSON.parse result
    parsed_body.filter { |p| p&.dig 'fields', 'holdable' }
        .map { |p| p&.dig 'key' }
  end

  def self.filter_holdables(calls:, holdable_locations:)
    calls.filter do |c|
      current_locations = c.items.map { |i| i.current_location }
      current_locations.filter {|loc| holdable_locations.include? loc }.present?
    end
  end

  def self.volumetric_natural_sort(calls:)
    calls.each { |i| i.record['naturalized_volumetric'] = naturalize(i.volumetric.to_s) }
        .sort_by { |i| i.record['naturalized_volumetric'] }
  end

  # Replace periods with spaces and then transform string into an array of "naturalized" values.
  # E.g., `"v.2 1956"` becomes  `["v ", 2.0, 1956.0]`
  #
  # Regex translation:
  # `scan` looks for either any non-whitespace character or digit OR any digit. This keeps non-digit
  # characters that aren't whitespace and digits to prep the sort. After that collect the array to
  # cast strings containing digits to Float (leave non-digits alone).
  def self.naturalize(value)
    value.gsub(/\./, ' ')
        .scan(/[^\s\d]+|\d+/)
        .map { |f| /\d+/.match?(f) ? f.to_f : f }
  end

  def self.volumetric?(calls:)
    calls&.find { |i| i.volumetric.present? }
  end

end
