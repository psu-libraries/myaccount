# frozen_string_literal: true

require 'rails_helper'
require 'support/fake_webservice'

class FakeGithub < FakeWebservice
  get '/repos/psu-libraries/myaccount/releases' do
    json_response 200, 'github_api/releases.json'
  end
end
