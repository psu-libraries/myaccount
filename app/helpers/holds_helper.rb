# frozen_string_literal: true

module HoldsHelper
  def render_queue_position(hold)
    return hold.queue_position.ordinalize unless hold.queue_position.nil?

    'Unknown'
  end

  def render_expiration_date(hold)
    return l(hold.expiration_date, format: :short) if hold.expiration_date

    'Never expires'
  end

  def render_status(hold)
    case hold.status_code
    when 'SUSPENDED'
      pretext = tag.em 'Suspended from'
      unless hold.suspend_end_date.nil?
        return pretext + ": #{l(hold.suspend_begin_date, format: :short)} - #{l(hold.suspend_end_date, format: :short)}"
      end

      'Inactive'
    else
      'Active'
    end
  end

  def render_pickup_libraries(selected)
    options_for_select(Hold::PICKUP_LOCATION_REQUESTED, disabled: '', selected: selected)
  end

  def default_pickup_by_date(make_default: false)
    return '' unless make_default

    DateTime.now.+(14.days).strftime('%Y-%m-%d')
  end

  def minimum_pickup_by_date
    DateTime.now.strftime('%Y-%m-%d')
  end
end
