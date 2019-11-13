# frozen_string_literal: true

class SessionsController < ApplicationController
  def index

    redirect_to summaries_url if current_user? || request.env['warden'].authenticate(:library_id)
    # TODO: redirect_to errors_url, alert: 'Unable to authenticate.'
    # TODO: flash.now.alert = request.env['warden'].message
  end
end
