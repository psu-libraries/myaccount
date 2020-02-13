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

    @holds
  end

  private

    def bib
      @body['fields']
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
      @body.dig('fields', 'callList')
        .try(:first)
        .dig('fields', 'itemList')
        .map { |i| i.dig('fields', 'barcode') }.sample
    end
end
