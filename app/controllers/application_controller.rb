# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :current_user?, :patron, :symphony_client

  def current_user
    session_data = request.env['warden'].user
    # Assuming the && is used solely to guard against nil. A new User is minted with every request based upon details
    # Warden set in the session data in cookies. So, new user every request, same SWS session data.
    session_data && User.new(session_data)
  end

  def current_user?
    current_user.present?
  end

  def patron
    return unless current_user?

    @patron ||= Patron.new(patron_info_response)
  end

  private

    def authenticate_webaccess
      redirect_to Settings.symws.webaccess_url + request.base_url
    end

    def symphony_client
      @symphony_client ||= SymphonyClient.new
    end

    def patron_info_response
      symphony_client.patron_info(current_user, item_details: item_details)
    end

    def authenticate_user!
      return redirect_to root_url unless current_user?

      renew_session_token unless symphony_client.ping?(current_user)
    end

    def renew_session_token
      request.env['warden'].logout

      authenticate_webaccess
    end

    def item_details
      {}
    end
end
