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
      symphony_client.patron_info(patron_key: current_user.patron_key,
                                  session_token: current_user.session_token,
                                  item_details: item_details)
    end

    def authenticate_user!
      # Go through auth (which happens at the root_url which is the SessionsController)
      unless current_user?
        set_original_fullpath
        return redirect_to root_url
      end

      # So current_user is set, Warden has got a user for us. However, our session with Sirsi WS has not gone stale.
      # We know it's stale because the ping returned something other than 200.
      renew_session_token unless symphony_client.ping?(current_user)
    end

    # This is used in the scenario where a user is not known to Warden yet. The application will redirect the
    # user back to this originally requested URL after the authentication has taken place.
    def set_original_fullpath
      session[:original_fullpath] = request.original_fullpath unless request.original_fullpath == '/'
    end

    # Things have gotten stale, clear user out by logging Warden out and send back through the authentication pipes.
    def renew_session_token
      request.env['warden'].logout

      authenticate_user!
    end

    def unless_maintenance_mode
      redirect_to root_path if Settings.maintenance_mode
    end

    def item_details
      {}
    end

    # Force page to reload on browser back in Rails
    def set_cache_headers
      response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      response.headers['Pragma'] = 'no-cache'
      response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
    end
end
