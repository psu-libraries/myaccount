# frozen_string_literal: true

class FinesController < ApplicationController
  before_action :authenticate_user!

  # Render a patron or groups fines or checkouts
  #
  # GET /fines
  def index
    @fines = fines
    @total_owed = fines.sum(&:owed_amount)
    # @checkouts = checkouts
  end

  private

    def fines
      patron.fines
    end

    def item_details
      { blockList: true }
    end
end
