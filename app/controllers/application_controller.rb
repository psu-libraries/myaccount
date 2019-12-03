# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :current_user?, :stale?, :patron, :symphony_client

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

    def symphony_client
      @symphony_client ||= SymphonyClient.new
    end

    def patron_info_response
      symphony_client.patron_info(current_user, item_details: item_details)
    end

    def authenticate_user!
      redirect_to root_url unless current_user?
    end

    def item_details
      {}
    end

    def stale?
      @patron.record == { 'messageList' => [{ 'code' => 'sessionTimedOut', 'message' => 'The session has timed out.' }] }
    end
end
