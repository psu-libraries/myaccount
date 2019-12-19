# frozen_string_literal: true

module HoldsHelper
  def render_queue_position(hold)
    return "Your position in the holds queue: #{hold.queue_position}" unless hold.queue_position.nil?

    'Unknown'
  end

  def render_expiration_date(hold)
    return l(hold.expiration_date, format: :short) if hold.expiration_date

    'Never expires'
  end

  def render_status(hold)
    case hold.status_code
    when 'SUSPENDED'
      pretext = content_tag 'em', 'Suspended from'
      unless hold.suspend_end_date.nil?
        return pretext + ": #{l(hold.suspend_begin_date, format: :short)} - #{l(hold.suspend_end_date, format: :short)}"
      end

      'Inactive'
    else
      'Active'
    end
  end
end
