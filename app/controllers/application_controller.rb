# frozen_string_literal: true

class ApplicationController < ActionController::Base

  helper_method :symphony_client
  def current_user
    session_data = request.env['warden'].user
    session_data && User.new(session_data)
  end

  def current_user?
    current_user.present?
  end

  def symphony_client
    @symphony_client ||= SymphonyClient.new
  end
end
