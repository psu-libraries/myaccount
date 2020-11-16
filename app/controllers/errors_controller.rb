# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.any { render status: 404, formats: :html, content_type: 'text/html' }
    end
  end

  def internal_server_error
    render status: 500
  end
end
