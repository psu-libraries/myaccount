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
      contents << l(checkout.recall_due_date, format: :long)
    end
    contents << l(checkout.due_date, format: :long)

    content_tag 'span', contents.join('<br>'), nil, false
  end

  def render_renewal_select(checkout)
    check_box_tag 'renewal_list[]', checkout.item_key, false, class: 'checkbox', multiple: true
  end

  def render_renew_button
    submit_tag 'Renew', class: 'btn btn-primary btn-renewable-submit'
  end
end
