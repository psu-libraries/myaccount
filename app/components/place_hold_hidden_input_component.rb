# frozen_string_literal: true

class PlaceHoldHiddenInputComponent < ActionView::Component::Base
  def initialize(bib:)
    @bib = bib
    @bib.body.extend Hashie::Extensions::DeepFind
  end

  def render?
    !@bib.body.deep_find 'volumetric'
  end

  def barcode
    @bib.body.deep_find 'barcode'
  end

  private

    attr_reader :bib
end
