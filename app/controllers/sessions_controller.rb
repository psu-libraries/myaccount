# frozen_string_literal: true

class SessionsController < ApplicationController
  # Render the application home page
  #
  # GET /
  def index
    redirect_to summaries_url if current_user? || request.env['warden'].authenticate(:library_id)
  end

  # Handle user logout
  #
  # GET /logout
  def destroy
    request.env['warden'].logout

    redirect_to root_url
  end
end
