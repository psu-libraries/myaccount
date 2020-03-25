# frozen_string_literal: true

class PlaceHoldErrorComponent < ActionView::Component::Base
  def initialize(result:)
    @bib = result[:failed_hold]
    @error_message = result[:error_message]
  end

  def render?
    error_message.present?
  end

  private

    attr_reader :bib, :error_message
end
