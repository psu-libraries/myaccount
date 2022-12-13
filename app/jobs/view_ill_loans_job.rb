# frozen_string_literal: true

class ViewIllLoansJob < ApplicationJob
  include ActionController::Rendering

  queue_as :default

  # 'type' can be either :holds or :checkouts
  def perform(webaccess_id, type)
    ill_loans = IlliadClient.new.send("get_loan_#{type}", webaccess_id)

    html = HoldsController.render template: "#{type}/ill_#{type}", layout: false, locals: { ill_loans: ill_loans }

    Redis.current.set("view_ill_#{type}_#{webaccess_id}", {
      result: :success,
      html: html
    }.to_json)
    nil
  rescue RuntimeError => e
    process_failure(e.message, webaccess_id, type)
  end

  private

    def process_failure(error_message:, webaccess_id:, type:)
      Sidekiq.logger.error("view_ill_#{type}_#{webaccess_id}: #{error_message}")
      Redis.current.set("view_ill_#{type}_#{webaccess_id}", {
        result: :failure,
        response: error_message
      }.to_json)
    end
end
