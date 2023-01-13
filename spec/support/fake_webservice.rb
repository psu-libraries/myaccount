# frozen_string_literal: true

require 'sinatra/base'

class FakeWebservice < Sinatra::Base
  private

    def json_response(response_code, file_name)
      content_type :json
      status response_code
      File.binread("#{File.dirname(__FILE__)}/data/#{file_name}")
    end
end
