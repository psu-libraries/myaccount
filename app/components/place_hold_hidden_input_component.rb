# frozen_string_literal: true

class PlaceHoldHiddenInputComponent < ActionView::Component::Base
  def initialize(bib:)
    @bib = bib
  end

  def render?
    !@bib.body.dig('fields', 'callList').try(:first).dig('fields', 'volumetric')
  end

  def barcode
    @bib.body.dig('fields', 'callList')
      .try(:first)
      .dig('fields', 'itemList')
      .map { |i| i.dig('fields', 'barcode') }.sample
  end

  private

    attr_reader :bib
end
