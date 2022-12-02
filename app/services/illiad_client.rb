# frozen_string_literal: true

# HTTP client wrapper for making requests to ILLiad Web Platform API
class IlliadClient
  def add_loan_transaction(transaction_info, params)
    body = {
      'Username': transaction_info.username,
      'RequestType': transaction_info.request_type,
      'LoanAuthor': transaction_info.loan_author,
      'ISSN': transaction_info.isbn,
      'LoanPublisher': transaction_info.loan_publisher,
      'LoanPlace': transaction_info.loan_place,
      'LoanDate': transaction_info.loan_date,
      'LoanTitle': transaction_info.loan_title,
      'LoanEdition': transaction_info.loan_edition,
      'ProcessType': transaction_info.process_type,
      'NotWantedAfter': params[:pickup_by_date],
      'AcceptAlternateEdition': params[:accept_alternate_edition] ? true : false
    }

    request('/IlliadWebPlatform/Transaction/', method: :post, json: body)
  end

  def add_loan_note(transaction_id, note)
    body = {
      "Note": note
    }
    request("/IlliadWebPlatform/transaction/#{transaction_id}/notes", method: :post, json: body)
  end

  def place_loan(transaction_info, params)
    note = params&.dig(:note)&.dig(:body)
    result = {}
    result[:message] = []
    response = add_loan_transaction(transaction_info, params)

    if response.status == 200
      result[:message].append('Loan Placed Successufly')
    else
      result[:error] = 'Failed to Place Loan'
      return result
    end

    if note.present?
      transaction_id = JSON.parse(response.body)['TransactionNumber']
      response = add_loan_note(transaction_id, note)
      result[:message].append('Failed to add note to transaction') unless response.status == 201
    end

    result
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
