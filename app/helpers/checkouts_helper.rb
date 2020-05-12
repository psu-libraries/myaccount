# frozen_string_literal: true

# Helper for checkouts views
module CheckoutsHelper
  def render_renew_button
    submit_tag 'Renew', class: 'btn btn-primary', data: { disable_with: 'Please wait...' }
  end
end
