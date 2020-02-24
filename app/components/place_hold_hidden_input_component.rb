# frozen_string_literal: true

class PlaceHoldHiddenInputComponent < ActionView::Component::Base
  def initialize(barcode:)
    @barcode = barcode
  end

  def render?
    barcode.present?
  end

  private

    attr_reader :barcode
end
