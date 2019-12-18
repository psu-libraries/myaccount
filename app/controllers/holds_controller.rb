# frozen_string_literal: true

class HoldsController < ApplicationController
  before_action :authenticate_user!

  # Render patron fines
  #
  # GET /fines
  def index
    @holds_ready = holds_ready
    @holds_not_ready = holds_not_ready
  end

  private

    def holds
      patron.holds
    end

    def holds_ready
      holds.select(&:ready_for_pickup?)
    end

    def holds_not_ready
      holds.reject(&:ready_for_pickup?)
    end

    def item_details
      { holdRecordList: true }
    end
end
