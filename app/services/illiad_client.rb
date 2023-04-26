# frozen_string_literal: true

# HTTP client wrapper for making requests to ILLiad Web Platform API
class IlliadClient
  attr_accessor :library

  def initialize(library)
    @library = library
  end

  def add_loan_transaction(transaction_info, params)
    body = {
      Username: transaction_info.username,
      RequestType: transaction_info.request_type,
      LoanAuthor: transaction_info.loan_author,
      ISSN: transaction_info.isbn,
      LoanPublisher: transaction_info.loan_publisher,
      LoanPlace: transaction_info.loan_place,
      LoanDate: transaction_info.loan_date,
      LoanTitle: transaction_info.loan_title,
      LoanEdition: transaction_info.loan_edition,
      ProcessType: transaction_info.process_type,
      NotWantedAfter: params[:pickup_by_date],
      AcceptAlternateEdition: params[:accept_alternate_edition] ? true : false,
      ItemInfo1: params[:accept_ebook] ? true : false,
      ItemInfo2: call_numbers(params)
    }

    request('/ILLiadWebPlatform/Transaction/', method: :post, json: body)
  end

  def add_loan_note(transaction_id, note)
    request("/ILLiadWebPlatform/transaction/#{transaction_id}/notes",
            method: :post,
            json: { Note: note })
  end

  def illiad_user(webaccess_id)
    request("/ILLiadWebPlatform/Users/#{webaccess_id}")
  end

  def patron_bad_standing?(patron)
    bad_standings = ['BO', 'DIS', 'B', 'BX']
    user_record = illiad_user(patron.id)

    JSON.parse(user_record.body)&.dig('Cleared').in?(bad_standings)
  end

  def find_or_create_user(patron)
    body = {
      Username: patron.id,
      ExternalUserId: patron.id,
      LastName: patron.last_name,
      FirstName: patron.first_name,
      AuthType: 'Default',
      Status: patron.profile,
      Cleared: 'No',
      NVTGC: 'UPILL',
      EMailAddress: patron.email_address,
      Site: Settings.illiad_locations[patron.library],
      Organization: patron.library,
      DeliveryMethod: 'Hold for Pickup',
      LoanDeliveryMethod: 'Hold for Pickup',
      NotificationMethod: 'Electronic'
    }

    illiad_user = illiad_user(patron.id)
    return illiad_user if illiad_user.status == 200

    request('/ILLiadWebPlatform/Users', method: :post, json: body)
  end

  def place_loan(transaction_info, params)
    response = add_loan_transaction(transaction_info, params)

    note = params&.dig(:note)&.dig(:body)
    if note.present? && response.status == 200
      transaction_id = JSON.parse(response.body)['TransactionNumber']
      # If add note fails, we will not inform
      # See https://github.com/psu-libraries/myaccount/issues/143#issuecomment-1347495833
      add_loan_note(transaction_id, note)
    end

    response
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
        raise JSON.parse(ill_response)['Message']
      end
    end

    def checkouts_query
      CGI.escape("(RequestType eq 'Loan') and " \
                 "((TransactionStatus eq 'Checked Out to Customer') or " \
                 "(TransactionStatus eq 'Awaiting Recalled Processing') or " \
                 "(TransactionStatus eq 'LST TESTING') or " \
                 "(startswith( TransactionStatus, 'Renewed by')))")
    end

    def holds_query
      query_str = +"(RequestType eq 'Loan') and ("
      holds_statuses.each_with_index do |status, i|
        query_str << ' or ' unless i.zero?
        query_str << "TransactionStatus eq '#{status}'"
      end
      query_str << "or (startswith( TransactionStatus, 'STAFF')))"
      CGI.escape(query_str)
    end

    def holds_statuses
      [
        'Awaiting Copyright Clearance',
        'Awaiting Request Processing',
        'Awaiting Account Validation',
        'In Depth Searching',
        'Awaiting Reshare Search',
        'UBorrow Find Item Search',
        'Awaiting RAPID Request Sending',
        'Awaiting Post Receipt Processing',
        'Request Sent',
        'In Transit to Pickup Location',
        'Customer Notified via E-Mail',
        'Cancelled by Customer',
        'Duplicate Request Review',
        'Request Available Locally',
        'Pattee Notices',
        'LST TESTING'
      ]
    end

    def request(path, method: :get, **other)
      HTTP.headers(headers).request(method, base_url + path, **other)
    end

    def base_url
      if library == "HERSHEY"
        Settings.illiad.hershey_url
      else
        Settings.illiad.url
      end
    end

    def headers
      { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key }
    end

    def call_numbers(params)
      [params['call_numbers']].flatten.compact.join(', ')
    end
end
