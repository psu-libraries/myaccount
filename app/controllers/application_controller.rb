# frozen_string_literal: true

class ApplicationController < ActionController::Base

  helper_method :symphony_client

  def symphony_client
    @symphony_client ||= SymphonyClient.new
  end
end
