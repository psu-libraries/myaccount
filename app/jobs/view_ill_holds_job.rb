# frozen_string_literal: true

class ViewIllHoldsJob < ApplicationJob
  include ActionController::Rendering

  queue_as :default

  def perform(webaccess_id)
    ill_holds = IlliadClient.new.get_loan_holds(webaccess_id)

    html = HoldsController.render template: 'holds/ill', layout: false, locals: { ill_holds: ill_holds }

    Redis.current.set("view_ill_holds_#{webaccess_id}", {
      result: :success,
      html: html
    }.to_json)
    nil
  rescue RuntimeError => e
    process_failure(e.message, webaccess_id)
  end

  private

    def process_failure(error_message:, webaccess_id:)
      Sidekiq.logger.error("view_holds_#{webaccess_id}: #{error_message}")
      Redis.current.set("view_holds_#{webaccess_id}", {
        result: :failure,
        response: error_message
      }.to_json)
    end
end
