# frozen_string_literal: true

# HTTP client wrapper for making requests to ILLiad Web Platform API
class IlliadClient
  def place_loan(transaction_info, params)
    body = {
      'Username': transaction_info.username,
      'RequestType': transaction_info.request_type,
      'LoanAuthor': transaction_info.loan_author,
      'LoanTitle': transaction_info.loan_title,
      'ProcessType': transaction_info.process_type,
      'NotWantedAfter': params[:pickup_by_date],
      'AcceptAlternateEdition': params[:accept_alternate_edition] ? true : false
    }

    request('/IlliadWebPlatform/Transaction/', method: :post, json: body)
  end

  private

    def request(path, method: :get, **other)
      HTTP.headers(headers).request(method, base_url + path, **other)
    end

    def base_url
      Settings.illiad.url
    end

    def headers
      { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key }
    end
end
