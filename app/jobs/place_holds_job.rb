# frozen_string_literal: true

class PlaceHoldsJob < ApplicationJob
  queue_as :default

  def perform(patron_key: patron_key, barcodes: barcodes, session_token: session_token, **hold_args)
    symphony_client = SymphonyClient.new
    patron_response = symphony_client.patron_info patron_key: patron_key,
                                                  session_token: session_token

    patron = Patron.new patron_response

    results = barcodes.each_with_object(success: [], error: []) do |barcode, status|
      response = symphony_client.place_hold(patron, session_token, barcode, hold_args)

      sirsi_response = SirsiResponse.new response

      if response.status == 200
        status[:success] << { barcode: barcode,
                              hold_key: sirsi_response.hold.key }
        Sidekiq.logger.error "raw response: #{sirsi_response.response_raw}"
        Sidekiq.logger.error "holdkey #{sirsi_response.hold.key}"
      else
        Sidekiq.logger.error("place_holds_results_#{patron_key} #{barcode}: #{sirsi_response.response_raw}")
        status[:error] << { barcode: barcode,
                            result: :failure,
                            error_message: sirsi_response.messages.first[:message] }
      end
    end

    results_builder = PlaceHoldResults::Builder.new(user_token: session_token,
                                                    client: symphony_client,
                                                    place_hold_results: results)

    html = ApplicationController.render partial: 'holds/results',
                                        layout: false,
                                        locals: { place_hold_results: results_builder.generate }

    Redis.current.set("place_holds_results_#{patron_key}", {
      id: patron.barcode.to_s,
      result: :success,
      response: html
    }.to_json)
  end
end
