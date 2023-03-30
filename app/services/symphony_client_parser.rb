# frozen_string_literal: true

# Responsible for parsing SymphonyClient responses.
class SymphonyClientParser
  def self.parsed_response(symphony_client, symphony_call, *params)
    kwargs = params.first.nil? ? {} : params.first
    client_response = symphony_client.send(symphony_call, **kwargs)
    JSON.parse client_response.body
  end
end
