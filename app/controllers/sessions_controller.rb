class SessionsController < ApplicationController
  helper_method :name
  def index
    @symphony_ok = symphony_client.ping

  end

  def name
    symphony_client.name
  end
end
