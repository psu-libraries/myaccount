# frozen_string_literal: true

class CheckoutDueDateComponent < ActionView::Component::Base
  def initialize(checkout:)
    @due_date = checkout.due_date_human
    @recalled = checkout.recalled?
    @recall_due_date = checkout.recall_due_date_human
  end

  def processed_due_date
    due_date = []

    if @recalled
      due_date << 'Recalled'
      due_date << @recall_due_date
    end

    due_date << @due_date

    due_date.join '<br>'
  end

  def render?
    @due_date
  end

  private

    attr_reader :due_date, :recalled, :recall_due_date
end
