# frozen_string_literal: true

class PlaceHoldDateComponent < ViewComponent::Base
  def initialize(validate_pickup_info: true, make_default: true)
    @make_default = make_default
    @validate_pickup_info = validate_pickup_info
  end

  def default_pickup_by_date
    return '' unless make_default

    DateTime.now.+(14.days).strftime('%Y-%m-%d')
  end

  def minimum_pickup_by_date
    DateTime.now.strftime('%Y-%m-%d')
  end

  private

    attr_reader :make_default, :validate_pickup_info
end
