# frozen_string_literal: true

class RenewCheckoutJob < ApplicationJob
  queue_as :default

  RENEWAL_CUSTOM_MESSAGELIST = {
    "hatErrorResponse.141": 'Denied: Renewal limit reached, cannot be renewed.',
    "hatErrorResponse.7703": 'Denied: Renewal limit reached, cannot be renewed.',
    "hatErrorResponse.105": 'Denied: Item has been recalled, cannot be renewed.',
    "hatErrorResponse.252": 'Denied: Item has holds, cannot be renewed.',
    "hatErrorResponse.46": 'Denied: Item on reserve, cannot be renewed.',
    "unhandledException": 'Denied: Item cannot be renewed.'
  }.with_indifferent_access

  def perform(resource:, item_key:, session_token:)
    symphony_client = SymphonyClient.new

    response = symphony_client.renew(
      resource: resource,
      item_key: item_key,
      session_token: session_token
    )

    case response.status
    when 200
      checkout = Checkout.new(JSON.parse(response.body)&.dig('circRecord'))

      due_date = ApplicationController.renderer.render(
        partial: 'checkouts/due_date',
        locals: { checkout: checkout }
      )

      Redis.current.set("renewal_#{item_key}", {
        id: item_key,
        result: :success,
        renewal_count: checkout.renewal_count,
        due_date: due_date,
        status: checkout.status_human
      }.to_json)
    else
      Sidekiq.logger.error("renewal_#{item_key}: #{response}")

      Redis.current.set("renewal_#{item_key}", {
        id: item_key,
        result: :failure,
        response: renewal_error_message(response),
        renewal_count: 'Error',
        due_date: 'Error',
        status: 'Error'
      }.to_json)
    end
  end

  private

    def renewal_error_message(response)
      parsed_messagelist = JSON.parse(response.body)&.dig('messageList')

      RENEWAL_CUSTOM_MESSAGELIST[parsed_messagelist&.first&.dig('code')] ||
        parsed_messagelist&.first&.dig('message')
    end
end
