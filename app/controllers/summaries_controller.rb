# frozen_string_literal: true

class SummariesController < ApplicationController
  before_action :authenticate_user!

  # Render the summary dashboard for a patron
  #
  # GET /summaries
  # GET /summaries.json
  def index
    @patron = patron
    @illiad_response = IlliadResponse.new(current_user.username)
  end

  private

    def item_details
      { all: true }
    end
end
