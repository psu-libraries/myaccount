# frozen_string_literal: true

class RenewalJob < ApplicationJob
  queue_as :default

  RENEWAL_CUSTOM_MESSAGELIST = {
    "hatErrorResponse.141": 'Renewal limit reached, cannot be renewed.',
    "hatErrorResponse.7703": 'Renewal limit reached, cannot be renewed.',
    "hatErrorResponse.105": 'Item has been recalled, cannot be renewed.',
    "hatErrorResponse.252": 'Item has holds, cannot be renewed.',
    "hatErrorResponse.46": 'Item on reserve, cannot be renewed.',
    "unhandledException": ''
  }.with_indifferent_access

  def perform(resource:, item_key:, session_token:)
    symphony_client = SymphonyClient.new
    redis_client = Redis.new
    response = symphony_client.renew(
      resource: resource,
      item_key: item_key,
      session_token: session_token
    )

    case response.status
    when 200
      parsed_response = JSON.parse response.body
      checkout = Checkout.new(parsed_response&.dig('circRecord'))

      redis_client.set("renewal_#{item_key}", {
        item_key: item_key,
        result: :success,
        renewal_count: checkout.renewal_count,
        due_date: ApplicationController.helpers.render_checkout_due_date(checkout.due_date_human),
        status: checkout.status_human
      }.to_json)
    else
      Sidekiq.logger.error("renewal_#{item_key}: #{error_message}")
      redis_client.set("renewal_#{item_key}", {
        item_key: item_key,
        result: :failure,
        error_message: renewal_error_message(response)
      }.to_json)
    end
  end

  private

    def error_code(response)
      return if response.status.ok?

      JSON.parse(response.body)&.dig('messageList')&.first&.dig('code')
    end

    def renewal_error_message(response)
      return if response.status.ok?

      RENEWAL_CUSTOM_MESSAGELIST[error_code(response)] ||
        JSON.parse(response.body)&.dig('messageList')&.first&.dig('message')
    end
end
