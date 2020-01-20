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

  def render_hold_select(hold)
    status = hold.ready_for_pickup? ? 'ready' : 'pending'
    check_box_tag 'hold_list[]', hold.key, false, data: { checkbox_type: status }, class: 'checkbox', multiple: true
  end

  def render_pickup_libraries
    default_choice = t('myaccount.hold.update_pickup.pickup_choose_text')
    Hash[default_choice, 'Not set'].merge(Hold::PICKUP_LOCATION_REQUESTED.invert)
  end
end
