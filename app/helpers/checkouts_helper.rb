# frozen_string_literal: true

# Helper for checkouts views
module CheckoutsHelper
  def render_checkout_status(checkout)
    return unless checkout.overdue?

    checkout.claims_returned? ? 'Claims Returned' : 'Overdue'
  end

  def render_checkout_due_date(checkout)
    contents = []
    if checkout.recalled?
      contents << 'Recalled'
      contents << format_due_date(checkout.recall_due_date)
    end
    contents << format_due_date(checkout.due_date)

    content_tag 'span', contents.join('<br>'), nil, false
  end

  def format_due_date(date)
    return l(date, format: :long) unless l(date, format: :time_only) == '11:59pm'

    l(date, format: :short)
  end

  def render_renewal_select(checkout)
    check_box_tag 'renewal_list[]', checkout.item_key, false,
                  data: { checkbox_type: 'renewal' }, class: 'checkbox', multiple: true
  end

  def render_renew_button
    submit_tag 'Renew', class: 'btn btn-primary btn-renewable-submit'
  end
end
