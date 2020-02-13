# frozen_string_literal: true

# Model for bib-level information in Symphony, it's basically a hold request factory
class Bib
  include BibRecord
  attr_reader :body, :barcode

  def initialize(body, holdable_locations)
    @body = body
    @barcode = random_barcode
    @holdable_locations = holdable_locations
  end

  # Take the array of holds and find out what is holdable. Order is important.
  #
  #  * Must be more than 1 overall potential holdables.
  #  * Each potential holdable must have a current location that is holdable.
  #  * To be a holdable set:
  #    * Must be at least one volumetric holdable.
  #    * Must be more than one holdables.
  #
  # In the case where a holdable set is not discovered, nil is returned and the barcode instance attribute
  # is available to process the hold request.
  def holdables
    return nil unless potential_holdables.count > 1

    filter_holdables

    return nil unless volumetric? && @holds.count > 1

    holds_sorted_naturally
  end

  private

    def bib
      @body['fields']
    end

    def holds_sorted_naturally
      @holds.each { |h| h.record['naturalized_volumetric'] = naturalize(h.volumetric.to_s) }
        .sort_by { |h| h.record['naturalized_volumetric'] }
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

    def potential_holdables
      items = body&.dig('fields', 'callList')
      @holds = items&.map { |i| Hold.new i }
    end

    def filter_holdables
      @holds&.filter! do |h|
        @holdable_locations.include? h.current_location
      end
    end

    def volumetric?
      @holds.find { |h| h.volumetric.present? }
    end

    def random_barcode
      bib.dig('callList')
        .try(:first)
        .dig('fields', 'itemList')
        .map { |i| i.dig('fields', 'barcode') }.sample
    end
end
