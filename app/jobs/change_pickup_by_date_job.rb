# frozen_string_literal: true

class ChangePickupByDateJob < ApplicationJob
  queue_as :default

  def perform(hold_key:, session_token:, pickup_by_date:)
    symphony_client = SymphonyClient.new
    redis_client = Redis.new

    response = symphony_client.not_needed_after(
      hold_key: hold_key,
      fill_by_date: pickup_by_date,
      session_token: session_token
    )

    case response.status
    when 200
      redis_client.set("pickup_by_date_#{hold_key}", {
        hold_id: hold_key,
        result: :success,
        new_value: pickup_by_date,
        new_value_formatted: Date.parse(pickup_by_date).strftime('%B %e, %Y')
      }.to_json)
    else
      error_message_raw = JSON.parse response.body
      error_message = error_message_raw&.dig('messageList')&.first&.dig('message') || 'Something went wrong'
      Sidekiq.logger.error("pickup_by_date_#{hold_key}: #{error_message}")
      redis_client.set("pickup_by_date_#{hold_key}", {
        hold_id: hold_key,
        result: :failure,
        response: error_message
      }.to_json)
    end
  end
end
