# frozen_string_literal: true

class ChangePickupLibraryJob < ApplicationJob
  queue_as :default

  def perform(hold_key:, session_token:, pickup_library:)
    symphony_client = SymphonyClient.new
    redis_client = Redis.new
    response = symphony_client.change_pickup_library(
      hold_key: hold_key,
      pickup_library: pickup_library,
      session_token: session_token
    )

    case response.status
    when 200
      human_readable_location = Hold::PICKUP_LOCATION_ACTUAL[pickup_library.to_sym]
      redis_client.set("pickup_library_#{hold_key}", {
        hold_id: hold_key,
        result: :success,
        new_value: human_readable_location,
        new_value_id: pickup_library
      }.to_json)
    else
      Sidekiq.logger.error("pickup_library_#{hold_key}: #{response.body}")
      redis_client.set("pickup_library_#{hold_key}", hold_id: hold_key, result: :failure, response: response.body)
    end
  end
end
