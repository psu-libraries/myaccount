# frozen_string_literal: true

class SessionsController < ApplicationController
  def index
    redirect_to summaries_url if current_user? || request.env['warden'].authenticate(:library_id)
  end
end
