# frozen_string_literal: true

class ChangePickupLibraryJob < ApplicationJob
  queue_as :default

  def perform(ws_args)
    symphony_client = SymphonyClient.new
    redis_client = Redis.new
    response = symphony_client.change_pickup_library(
      hold_key: ws_args[:hold_key],
      pickup_library: ws_args[:pickup_library],
      session_token: ws_args[:session_token]
    )

    case response.status
    when 200
      human_readable_location = Hold::PICKUP_LOCATION_ACTUAL[ws_args[:pickup_library].to_sym]
      redis_client.set(ws_args[:hold_key], {
        hold_id: ws_args[:hold_key],
        result: :success,
        new_value: human_readable_location,
        new_value_id: ws_args[:pickup_library]
      }.to_json)
    else
      Sidekiq.logger.error("#{ws_args[:hold_key]}: #{response.body}")
      redis_client.set(ws_args[:hold_key], hold_id: ws_args[:hold_key], result: :failure, response: response.body)
    end
  end
end
