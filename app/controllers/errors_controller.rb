# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.all { render status: 404, formats: :html, content_type: 'text/html' }
    end
  end

  def internal_server_error
    render status: 500
  end
end
