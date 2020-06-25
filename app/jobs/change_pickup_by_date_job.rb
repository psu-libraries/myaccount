# frozen_string_literal: true

class ChangePickupByDateJob < ApplicationJob
  queue_as :default

  def perform(hold_key:, session_token:, pickup_by_date:)
    symphony_client = SymphonyClient.new

    response = symphony_client.not_needed_after(
      hold_key: hold_key,
      fill_by_date: pickup_by_date,
      session_token: session_token
    )

    case response.status
    when 200
      Redis.current.set("pickup_by_date_#{hold_key}", {
        id: hold_key,
        result: :success,
        new_value: pickup_by_date,
        new_value_formatted: Date.parse(pickup_by_date).strftime('%B %-d, %Y')
      }.to_json)
    else
      error_message_raw = JSON.parse response.body
      error_message = error_message_raw&.dig('messageList')&.first&.dig('message') || 'Something went wrong'

      parsed_hold = SymphonyClientParser::parsed_response(symphony_client, :get_hold_info, hold_key, session_token)
      hold = Hold.new parsed_hold

      html = RedisJobsController.render template: 'sirsi_response/error', layout: false, locals: { id: hold_key,
                                                                                                   title: hold.title,
                                                                                                   error_message: error_message }

      Sidekiq.logger.error("pickup_by_date_#{hold_key}: #{error_message}")
      Redis.current.set("pickup_by_date_#{hold_key}", {
        id: hold_key,
        result: :failure,
        response: html,
        new_value: 'Error',
        new_value_formatted: 'Error'
      }.to_json)
    end
  end
end
