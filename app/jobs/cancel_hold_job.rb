# frozen_string_literal: true

class CancelHoldJob < ApplicationJob
  queue_as :default

  def perform(hold_key:, session_token:)
    symphony_client = SymphonyClient.new

    response = symphony_client.cancel_hold(hold_key: hold_key, session_token: session_token)

    case response.status
    when 200
      Redis.current.set("cancel_hold_#{hold_key}", {
        id: hold_key,
        result: :success,
        response: '<p class=\'text-danger\'>Cancelled</p>'
      }.to_json)
    else
      processed_error = SirsiResponse::Error.new(error_message_raw: JSON.parse(response.body),
                                                 symphony_client: symphony_client,
                                                 key: hold_key,
                                                 session_token: session_token,
                                                 bib_type: :hold)

      Sidekiq.logger.error "cancel_hold_#{hold_key}: #{processed_error.log}"

      Redis.current.set("cancel_hold_#{hold_key}", {
        id: hold_key,
        result: :failure,
        response: 'Error',
        display_error: processed_error.html
      }.to_json)
    end
  end
end
