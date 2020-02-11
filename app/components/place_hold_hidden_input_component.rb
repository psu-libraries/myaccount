# frozen_string_literal: true

class PlaceHoldHiddenInputComponent < ActionView::Component::Base
  def initialize(bib:)
    @bib = bib
  end

  def render?
    bib.holdables.nil?
  end

  private

    attr_reader :bib
end
