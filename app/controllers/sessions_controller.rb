class SessionsController < ApplicationController

  def index
    # @symphony_ok = symphony_client.ping

    if current_user?
      redirect_to summaries_url
    else
      if request.env['warden'].authenticate(:library_id)
        redirect_to summaries_url
      else
        # flash.now.alert = request.env['warden'].message
        # redirect_to errors_url, alert: 'Unable to authenticate.'
      end
    end
  end
end
