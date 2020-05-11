# frozen_string_literal: true

# Helper for checkouts views
module CheckoutsHelper
  def render_checkout_due_date(due_dates)
    content_tag 'span', due_dates.join('<br>'), nil, false
  end

  def render_renew_button
    submit_tag 'Renew', class: 'btn btn-primary', data: { disable_with: 'Please wait...' }
  end
end
