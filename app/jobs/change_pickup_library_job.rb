# frozen_string_literal: true

class ChangePickupLibraryJob < ApplicationJob
  queue_as :default

  def perform(hold_key:, session_token:, pickup_library:)
    symphony_client = SymphonyClient.new

    response = symphony_client.change_pickup_library(
      hold_key: hold_key,
      pickup_library: pickup_library,
      session_token: session_token
    )

    case response.status
    when 200
      human_readable_location = Hold::PICKUP_LOCATION_ACTUAL[pickup_library.to_sym]
      Redis.current.set("pickup_library_#{hold_key}", {
        id: hold_key,
        result: :success,
        response: {
          new_value: human_readable_location,
          new_value_id: pickup_library
        }
      }.to_json)
    else
      processed_error = SirsiResponse::Error.new(error_message_raw: JSON.parse(response.body),
                                                 symphony_client: symphony_client,
                                                 symphony_call: :get_hold_info,
                                                 key: hold_key,
                                                 session_token: session_token,
                                                 bib_type: :hold)

      Sidekiq.logger.error("pickup_library_#{hold_key}: #{processed_error.log}")

      Redis.current.set("pickup_library_#{hold_key}", {
        id: hold_key,
        result: :failure,
        response: {
          new_value: 'Error',
          new_value_id: 'Error'
        },
        display_error: processed_error.html
      }.to_json)
    end
  end
end
