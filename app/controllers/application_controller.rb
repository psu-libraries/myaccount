# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :patron, :symphony_client

  def current_user
    session_data = request.env['warden'].user
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
      symphony_client.patron_info(current_user.patronKey)
    end

    def authenticate_user!
      redirect_to root_url unless current_user?
    end
end
