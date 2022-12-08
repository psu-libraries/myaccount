# frozen_string_literal: true

# HTTP client wrapper for making requests to ILLiad Web Platform API
class IlliadClient
  def place_loan(transaction_info, params)
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

  def get_loan_checkouts(webaccess_id)
    ill_get_request(webaccess_id, checkouts_query)
  end

  def get_loan_holds(webaccess_id)
    ill_get_request(webaccess_id, holds_query)
  end

  private

    def ill_get_request(webaccess_id, query)
      ill_response = request("/ILLiadWebPlatform/Transaction/UserRequests/#{webaccess_id}?$filter=" + query)
      if ill_response.status == 200
        JSON.parse(ill_response).map { |record| IllLoan.new(record) }
      else
        raise ill_response.to_s
      end
    end

    def checkouts_query
      CGI.escape("(RequestType eq 'Loan') and " \
                 "((TransactionStatus eq 'Checked Out to Customer') or " \
                 "(startswith( TransactionStatus, 'Renewed by')))")
    end

    def holds_query
      query_str = +"(RequestType eq 'Loan') and ("
      holds_statuses.each_with_index do |status, i|
        query_str << ' or ' unless i.zero?
        query_str << "TransactionStatus eq '#{status}'"
      end
      query_str << ')'
      CGI.escape(query_str)
    end

    def holds_statuses
      [
        'Awaiting Copyright Clearance',
        'Awaiting Request Processing',
        'Awaiting Request Processing',
        'Awaiting Account Validation',
        'In Depth Searching',
        'Awaiting Reshare Search',
        'UBorrow Find Item Search',
        'Awaiting RAPID Request Sending',
        'Awaiting Post Receipt Processing',
        'Request Sent',
        'In Transit to Pickup Location',
        'Customer Notified via E-mail',
        'Cancelled by Customer',
        'Duplicate Request Review',
        'Request Available Locally'
      ]
    end

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
