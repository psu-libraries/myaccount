# frozen_string_literal: true

class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  # Render a list of checkouts and renewals for patron
  #
  # GET /checkouts
  def index
    @checkouts = checkouts
  end

  private

    def checkouts
      patron.checkouts.sort_by(&:due_date)
    end

    def item_details
      { circRecordList: true }
    end
end
