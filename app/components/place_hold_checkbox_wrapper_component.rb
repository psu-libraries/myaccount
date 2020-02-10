# frozen_string_literal: true

class PlaceHoldCheckboxWrapperComponent < ActionView::Component::Base
  def initialize(items:)
    @items = items
  end

  def render?
    !!@items.find { |i| i.record['fields']['volumetric'].present? }
  end

  private

    attr_reader :items
end
