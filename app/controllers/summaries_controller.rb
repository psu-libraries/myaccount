# frozen_string_literal: true

class SummariesController < ApplicationController
  before_action :authenticate_user!

  # Render the summary dashboard for a patron
  #
  # GET /summaries
  # GET /summaries.json
  def index
    @patron = patron

    if stale?
      request.env['warden'].logout
      redirect_to Settings.symws.webaccess_url + request.base_url
    end
  end

  private

    def stale?
      patron.record == { 'messageList' => [{ 'code' => 'sessionTimedOut', 'message' => 'The session has timed out.' }] }
    end
end
