# frozen_string_literal: true

class ViewIlliadLoansJob < ApplicationJob
  include ActionController::Rendering

  queue_as :default

  LOAN_TYPES = %i{holds checkouts}.freeze

  def perform(webaccess_id:, type:, library_key:)
    raise StandardError, "Invalid Loan Type '#{type}'.  Must be :holds or :checkouts." unless LOAN_TYPES.include?(type)

    illiad_loans = IlliadClient.new.send("get_loan_#{type}", webaccess_id)

    # IlliadClient usually returns an array, If we don't return an array we send the 
    # result to process_failure. We do this to avoid raising an exception in IlliadClient
    if illiad_loans.instance_of?(Array)

      html = HoldsController.render template: "#{type}/ill_#{type}", layout: false,
                                    locals: { illiad_loans:, library_key: }

      Redis.current.set("view_ill_#{type}_#{webaccess_id}", {
        result: :success,
        html:
      }.to_json)
      nil
    else
      message = JSON.parse(illiad_loans)['Message']
      process_failure(error_message: message, webaccess_id:, type:)
    end
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
