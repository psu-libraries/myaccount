# frozen_string_literal: true

class CancelHoldJob < ApplicationJob
  queue_as :default

  def perform(hold_key:, session_token:)
    symphony_client = SymphonyClient.new
    redis_client = Redis.new

    response = symphony_client.cancel_hold(hold_key: hold_key, session_token: session_token)

    case response.status
    when 200
      redis_client.set("cancel_hold_#{hold_key}", {
        hold_id: hold_key,
        result: :success
      }.to_json)
    else
      error_message_raw = JSON.parse response.body
      error_message = error_message_raw&.dig('messageList')&.first&.dig('message') || 'Something went wrong'
      Sidekiq.logger.error("cancel_hold_#{hold_key}: #{error_message}")
      redis_client.set("cancel_hold_#{hold_key}", {
        hold_id: hold_key,
        result: :failure,
        response: error_message
      }.to_json)
    end
  end
end
