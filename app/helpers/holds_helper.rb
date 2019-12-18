# frozen_string_literal: true

module HoldsHelper
  def render_queue_position(hold)
    return "Your position in the holds queue: #{hold.queue_position}" unless hold.queue_position.nil?

    "Unknown"
  end
end
