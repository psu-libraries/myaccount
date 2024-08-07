# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IlliadClient do
  subject(:client) { described_class.new }

  let(:mock_patron) do
    instance_double(Patron, barcode: '12345678', email_address: 'abc123@psu.edu', profile: 'profile',
                            last_name: 'smith', first_name: 'bob', id: 'abc123', library: 'UP_PAT',
                            key: '1234567', ill_ineligible?: false,
                            standing_human: '')
  end

  describe '#place_loan' do
    let(:params_with_note) do
      {
        catkey: '1',
        pickup_by_date: '2022-12-02',
        accept_alternate_edition: true,
        note: {
          body: 'this is a note'
        }
      }
    end

    let(:params) do
      {
        catkey: '1',
        pickup_by_date: '2022-12-02',
        accept_alternate_edition: true,
        call_numbers: params_call_numbers
      }.with_indifferent_access
    end

    let(:params_call_numbers) { '' }
    let(:request_call_numbers) { '' }

    let(:request_body) do
      {
        Username: 'xyz12',
        RequestType: 'Loan',
        LoanAuthor: 'Great Author',
        ISSN: '1234567',
        LoanPublisher: 'Great Publisher',
        LoanPlace: 'The Great Place',
        LoanDate: '2022-11-01',
        LoanTitle: 'Some Great Book',
        LoanEdition: 'Test Edition',
        ProcessType: 'Borrowing',
        NotWantedAfter: '2022-12-02',
        AcceptAlternateEdition: true,
        ItemInfo1: false,
        ItemInfo2: request_call_numbers
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
        stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 200, body: { TransactionNumber: 1234 }.to_json)

        stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/transaction/1234/notes")
          .with(body: { Note: params_with_note[:note][:body] }.to_json,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 201)
      end

      it 'adds a note' do
        expect(place_loan_response_with_note.status).to eq 200
      end
    end

    context 'when place hold is successful' do
      before do
        stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 200)
      end

      it 'returns status success' do
        expect(place_loan_response.status).to eq 200
      end
    end

    context 'when place hold is unsuccessful' do
      before do
        stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 400)
      end

      it 'returns an error' do
        expect(place_loan_response.status).to eq 400
      end
    end

    context 'when loan item has volumetrics' do
      let(:params_call_numbers) { ['call_number1', 'call_number2'] }
      let(:request_call_numbers) { 'call_number1, call_number2' }

      before do
        stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 200)
      end

      it 'returns status success' do
        expect(place_loan_response.status).to eq 200
      end
    end
  end

  describe '#find_or_create_user' do
    context 'when the user does exist' do
      let (:resp) { client.find_or_create_user(mock_patron) }

      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Users/abc123")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 200)
      end

      it 'returns 200' do
        expect(resp.status).to eq(200)
      end
    end

    context 'when the user does not exist' do
      let (:resp) { client.find_or_create_user(mock_patron) }

      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Users/abc123")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 404)
        stub_request(:post, "#{Settings.illiad.url}/ILLiadWebPlatform/Users")
          .with(headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 200)
      end

      it 'returns 200' do
        expect(resp.status).to eq(200)
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
                           "nStatus%20eq%20'Awaiting%20Recalled%20Processing')%20or%20(Transa" \
                           "ctionStatus%20eq%20'LST%20TESTING')%20or%20(startswith(%20Transac" \
                           "tionStatus,%20'Renewed%20by')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
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
                           "nStatus%20eq%20'Awaiting%20Recalled%20Processing')%20or%20(Transa" \
                           "ctionStatus%20eq%20'LST%20TESTING')%20or%20(startswith(%20Transac" \
                           "tionStatus,%20'Renewed%20by')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 400, body: '{"Message":"400 Error"}')
      end

      it 'returns an error' do
        pending 'refactor of summaries page'
        expect { get_loan_checkouts_response }.to raise_error(StandardError, '400 Error')
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
                           "g%20Request%20Processing'%20or%20TransactionStatus%20eq%20'Awaiting%20Acc" \
                           "ount%20Validation'%20or%20TransactionStatus%20eq%20'In%20Depth%20Searchin" \
                           "g'%20or%20TransactionStatus%20eq%20'Awaiting%20Reshare%20Search'%20or%20T" \
                           "ransactionStatus%20eq%20'UBorrow%20Find%20Item%20Search'%20or%20Transacti" \
                           "onStatus%20eq%20'Awaiting%20RAPID%20Request%20Sending'%20or%20Transaction" \
                           "Status%20eq%20'Awaiting%20Post%20Receipt%20Processing'%20or%20Transaction" \
                           "Status%20eq%20'Request%20Sent'%20or%20TransactionStatus%20eq%20'In%20Tran" \
                           "sit%20to%20Pickup%20Location'%20or%20TransactionStatus%20eq%20'Customer%2" \
                           "0Notified%20via%20E-Mail'%20or%20TransactionStatus%20eq%20'Cancelled%20by" \
                           "%20Customer'%20or%20TransactionStatus%20eq%20'Duplicate%20Request%20Revie" \
                           "w'%20or%20TransactionStatus%20eq%20'Request%20Available%20Locally'%20or%2" \
                           "0TransactionStatus%20eq%20'Pattee%20Notices'%20or%20TransactionStatus%20e" \
                           "q%20'LST%20TESTING'or%20(startswith(%20TransactionStatus,%20'STAFF')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
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
                           "g%20Request%20Processing'%20or%20TransactionStatus%20eq%20'Awaiting%20Acc" \
                           "ount%20Validation'%20or%20TransactionStatus%20eq%20'In%20Depth%20Searchin" \
                           "g'%20or%20TransactionStatus%20eq%20'Awaiting%20Reshare%20Search'%20or%20T" \
                           "ransactionStatus%20eq%20'UBorrow%20Find%20Item%20Search'%20or%20Transacti" \
                           "onStatus%20eq%20'Awaiting%20RAPID%20Request%20Sending'%20or%20Transaction" \
                           "Status%20eq%20'Awaiting%20Post%20Receipt%20Processing'%20or%20Transaction" \
                           "Status%20eq%20'Request%20Sent'%20or%20TransactionStatus%20eq%20'In%20Tran" \
                           "sit%20to%20Pickup%20Location'%20or%20TransactionStatus%20eq%20'Customer%2" \
                           "0Notified%20via%20E-Mail'%20or%20TransactionStatus%20eq%20'Cancelled%20by" \
                           "%20Customer'%20or%20TransactionStatus%20eq%20'Duplicate%20Request%20Revie" \
                           "w'%20or%20TransactionStatus%20eq%20'Request%20Available%20Locally'%20or%2" \
                           "0TransactionStatus%20eq%20'Pattee%20Notices'%20or%20TransactionStatus%20e" \
                           "q%20'LST%20TESTING'or%20(startswith(%20TransactionStatus,%20'STAFF')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', ApiKey: Settings.illiad.api_key })
          .to_return(status: 400, body: '{"Message":"400 Error"}')
      end

      it 'returns an error' do
        pending 'refactor of summaries page'
        expect { get_loan_holds_response }.to raise_error(StandardError, '400 Error')
      end
    end
  end
end
