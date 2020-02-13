# frozen_string_literal: true

class PlaceHoldCheckboxComponent < ActionView::Component::Base
  def initialize(barcode:, call_number:, pickup_library:)
    @barcode = barcode
    @call_number = call_number
    @pickup_library = pickup_library
  end

  def render?
    barcode.present?
  end

  private

    attr_reader :barcode, :call_number, :pickup_library
end
