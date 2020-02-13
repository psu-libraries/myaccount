# frozen_string_literal: true

class PlaceHoldCheckboxWrapperComponent < ActionView::Component::Base
  def initialize(holdables: nil)
    @holdables = holdables
  end

  def render?
    holdables.present?
  end

  private

    attr_reader :holdables
end
