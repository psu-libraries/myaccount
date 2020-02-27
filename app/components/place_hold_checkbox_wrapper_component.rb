# frozen_string_literal: true

class PlaceHoldCheckboxWrapperComponent < ActionView::Component::Base
  def initialize(call_list: nil)
    @call_list = call_list
  end

  def render?
    call_list.present?
  end

  private

    attr_reader :call_list
end
