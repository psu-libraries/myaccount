# frozen_string_literal: true

# Helper for checkouts views
module CheckoutsHelper
  def render_checkout_title(checkout)
    title = checkout.title
    title += " / #{checkout.author}" if checkout.author.present?
    link_to title, "https://catalog.libraries.psu.edu/catalog/#{checkout.catkey}"
  end

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
    contents << l(checkout.original_due_date, format: :long)

    content_tag 'span', contents.join('<br>'), nil, false
  end
end
