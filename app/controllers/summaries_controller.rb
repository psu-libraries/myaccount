# frozen_string_literal: true

class SummariesController < ApplicationController
  before_action :authenticate_user!

  # Render the summary dashboard for a patron
  #
  # GET /summaries
  # GET /summaries.json
  def index
    @patron = patron
    @illiad_holds = IlliadClient.new.send("get_loan_#{:holds}", current_user.username)
    @illiad_checkouts = IlliadClient.new.send("get_loan_#{:checkouts}", current_user.username)
    @ill_recalled = ill_recalled
    @ill_overdue = ill_overdue
    @ill_ready_for_pickup = ill_ready_for_pickup
  end

  private

    def item_details
      { all: true }
    end

    def ill_recalled
      count = 0
      @illiad_checkouts.each_with_index do |hold|
        count += 1 if hold.status == 'Recalled, Please Return ASAP'
      end
      count
    end

    def ill_overdue
      count = 0
      @illiad_checkouts.each_with_index do |hold|
        if hold.due_date.present?
          count += 1 if hold.due_date < Time.now
        end
      end
      count
    end

    def ill_ready_for_pickup
      count = 0
      @illiad_holds.each_with_index do |hold|
        count += 1 if hold.status == 'Available for Pickup'
      end
      count
    end
end
