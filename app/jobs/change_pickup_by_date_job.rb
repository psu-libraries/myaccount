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
          new_value: pickup_by_date
      }.to_json)
      Sidekiq.logger.info 'success!'
    else
      Sidekiq.logger.error("pickup_by_date_#{hold_key}: #{response.body}")
      redis_client.set("pickup_by_date_#{hold_key}", hold_id: hold_key, result: :failure, response: response.body)
    end
  end
end
