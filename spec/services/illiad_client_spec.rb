# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IlliadClient do
  subject(:client) { described_class.new }

  describe '#place_loan' do
    let(:params_with_note) do
      {
        catkey: '1',
        pickup_by_date: '2022-12-02',
        accept_alternate_edition: true,
        "note": {
          "body": 'this is a note'
        }
      }
    end

    let(:params) do
      {
        catkey: '1',
        pickup_by_date: '2022-12-02',
        accept_alternate_edition: true
      }
    end

    let(:request_body) do
      {
        'Username': 'xyz12',
        'RequestType': 'Loan',
        'LoanAuthor': 'Great Author',
        'ISSN': '1234567',
        'LoanPublisher': 'Great Publisher',
        'LoanPlace': 'The Great Place',
        'LoanDate': '2022-11-01',
        'LoanTitle': 'Some Great Book',
        'LoanEdition': 'Test Edition',
        'ProcessType': 'Borrowing',
        'NotWantedAfter': '2022-12-02',
        'AcceptAlternateEdition': true,
        'ItemInfo1': false,
        'ItemInfo2': ''
      }
    end

    let(:ill_transaction) do
      instance_double(IllTransaction,
                      username: 'xyz12',
                      request_type: 'Loan',
                      process_type: 'Borrowing',
                      loan_title: 'Some Great Book',
                      loan_author: 'Great Author',
                      isbn: '1234567',
                      loan_publisher: 'Great Publisher',
                      loan_place: 'The Great Place',
                      loan_date: '2022-11-01',
                      loan_edition: 'Test Edition')
    end

    let(:place_loan_response) { client.place_loan(ill_transaction, params) }
    let(:place_loan_response_with_note) { client.place_loan(ill_transaction, params_with_note) }

    context 'when notes are added' do
      before do
        stub_request(:post, "#{Settings.illiad.url}/IlliadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 200, body: { "TransactionNumber": 1234 }.to_json)

        stub_request(:post, "#{Settings.illiad.url}/IlliadWebPlatform/transaction/1234/notes")
          .with(body: { "Note": params_with_note[:note][:body] }.to_json,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 201)
      end
    end

    context 'when place hold is successful' do
      before do
        stub_request(:post, "#{Settings.illiad.url}/IlliadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 200)
      end

      it 'returns status success' do
        expect(place_loan_response.status).to eq(200)
      end
    end

    context 'when place hold is unsuccessful' do
      before do
        stub_request(:post, "#{Settings.illiad.url}/IlliadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 400)
      end

      it 'returns an error' do
        expect(place_loan_response.status).to eq (400)
      end
    end
  end

  describe '#get_loan_checkouts' do
    let(:get_loan_checkouts_response) { client.get_loan_checkouts('test123') }

    context 'when getting loan checkouts is successful' do
      let(:return_body) do
        '[{"TransactionNumber":123456, "Username":"test123", "RequestType":"Loan",
           "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title",
           "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"},
          {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
            "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title", "LoanPublisher":null,
            "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"}]'
      end

      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/UserRequests/" \
                            "test123?$filter=(RequestType%20eq%20'Loan')%20and%20((Transaction" \
                            "Status%20eq%20'Checked%20Out%20to%20Customer')%20or%20(Transactio" \
                            "nStatus%20eq%20'LST%20TESTING')%20or%20(startswith(%20Transaction" \
                            "Status,%20'Renewed%20by')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 200, body: return_body)
      end

      it 'returns an array of loan checkouts' do
        expect(get_loan_checkouts_response.count).to eq 2
        expect(get_loan_checkouts_response.first.title).to eq 'The Book Title'
        expect(get_loan_checkouts_response.first.class).to eq IllLoan
      end
    end

    context 'when getting loan checkouts is unsuccessful' do
      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/UserRequests/" \
                            "test123?$filter=(RequestType%20eq%20'Loan')%20and%20((Transaction" \
                            "Status%20eq%20'Checked%20Out%20to%20Customer')%20or%20(Transactio" \
                            "nStatus%20eq%20'LST%20TESTING')%20or%20(startswith(%20Transaction" \
                            "Status,%20'Renewed%20by')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 400, body: '{"Message":"400 Error"}')
      end

      it 'returns an error' do
        expect { get_loan_checkouts_response }.to raise_error(RuntimeError, '400 Error')
      end
    end
  end

  describe '#get_loan_holds' do
    let(:get_loan_holds_response) { client.get_loan_holds('test123') }

    context 'when getting loan holds is successful' do
      let(:return_body) do
        '[{"TransactionNumber":123456, "Username":"test123", "RequestType":"Loan",
           "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title",
           "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Awaiting Request Processing"},
          {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
           "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title", "LoanPublisher":null,
           "LoanPlace":null, "TransactionStatus":"Request Sent"}]'
      end

      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/UserRequests/test123" \
                           "?$filter=(RequestType%20eq%20'Loan')%20and%20(TransactionStatus%20eq%20'A" \
                           "waiting%20Copyright%20Clearance'%20or%20TransactionStatus%20eq%20'Awaitin" \
                           "g%20Request%20Processing'%20or%20TransactionStatus%20eq%20'Awaiting%20Req" \
                           "uest%20Processing'%20or%20TransactionStatus%20eq%20'Awaiting%20Account%20" \
                           "Validation'%20or%20TransactionStatus%20eq%20'In%20Depth%20Searching'%20or" \
                           "%20TransactionStatus%20eq%20'Awaiting%20Reshare%20Search'%20or%20Transact" \
                           "ionStatus%20eq%20'UBorrow%20Find%20Item%20Search'%20or%20TransactionStatu" \
                           "s%20eq%20'Awaiting%20RAPID%20Request%20Sending'%20or%20TransactionStatus%" \
                           "20eq%20'Awaiting%20Post%20Receipt%20Processing'%20or%20TransactionStatus%" \
                           "20eq%20'Request%20Sent'%20or%20TransactionStatus%20eq%20'In%20Transit%20t" \
                           "o%20Pickup%20Location'%20or%20TransactionStatus%20eq%20'Customer%20Notifi" \
                           "ed%20via%20E-mail'%20or%20TransactionStatus%20eq%20'Cancelled%20by%20Cust" \
                           "omer'%20or%20TransactionStatus%20eq%20'Duplicate%20Request%20Review'%20or" \
                           "%20TransactionStatus%20eq%20'Request%20Available%20Locally'%20or%20Transa" \
                           "ctionStatus%20eq%20'LST%20TESTING'or%20(startswith(%20TransactionStatus,%" \
                           "20'STAFF')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 200, body: return_body)
      end

      it 'returns an array of loan holds' do
        expect(get_loan_holds_response.count).to eq 2
        expect(get_loan_holds_response.first.title).to eq 'The Book Title'
        expect(get_loan_holds_response.first.class).to eq IllLoan
      end
    end

    context 'when getting loan holds is unsuccessful' do
      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/UserRequests/test123" \
                           "?$filter=(RequestType%20eq%20'Loan')%20and%20(TransactionStatus%20eq%20'A" \
                           "waiting%20Copyright%20Clearance'%20or%20TransactionStatus%20eq%20'Awaitin" \
                           "g%20Request%20Processing'%20or%20TransactionStatus%20eq%20'Awaiting%20Req" \
                           "uest%20Processing'%20or%20TransactionStatus%20eq%20'Awaiting%20Account%20" \
                           "Validation'%20or%20TransactionStatus%20eq%20'In%20Depth%20Searching'%20or" \
                           "%20TransactionStatus%20eq%20'Awaiting%20Reshare%20Search'%20or%20Transact" \
                           "ionStatus%20eq%20'UBorrow%20Find%20Item%20Search'%20or%20TransactionStatu" \
                           "s%20eq%20'Awaiting%20RAPID%20Request%20Sending'%20or%20TransactionStatus%" \
                           "20eq%20'Awaiting%20Post%20Receipt%20Processing'%20or%20TransactionStatus%" \
                           "20eq%20'Request%20Sent'%20or%20TransactionStatus%20eq%20'In%20Transit%20t" \
                           "o%20Pickup%20Location'%20or%20TransactionStatus%20eq%20'Customer%20Notifi" \
                           "ed%20via%20E-mail'%20or%20TransactionStatus%20eq%20'Cancelled%20by%20Cust" \
                           "omer'%20or%20TransactionStatus%20eq%20'Duplicate%20Request%20Review'%20or" \
                           "%20TransactionStatus%20eq%20'Request%20Available%20Locally'%20or%20Transa" \
                           "ctionStatus%20eq%20'LST%20TESTING'or%20(startswith(%20TransactionStatus,%" \
                           "20'STAFF')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 400, body: '{"Message":"400 Error"}')
      end

      it 'returns an error' do
        expect { get_loan_holds_response }.to raise_error(RuntimeError, '400 Error')
      end
    end
  end
end
