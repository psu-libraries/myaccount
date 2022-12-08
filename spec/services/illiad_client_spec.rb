# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IlliadClient do
  subject(:client) { described_class.new }

  describe '#place_loan' do
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
        'AcceptAlternateEdition': true
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

    context 'when place hold is successful' do
      before do
        stub_request(:post, "#{Settings.illiad.url}/IlliadWebPlatform/Transaction/")
          .with(body: request_body,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 200)
      end

      it 'returns status 200' do
        expect(place_loan_response.status).to eq 200
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
        expect(place_loan_response.status).to eq 400
      end
    end
  end

  describe "#get_loan_checkouts" do
    let(:get_loan_checkouts_response) { client.get_loan_checkouts('test123') }

    context 'when getting loan checkouts is successful' do
      let(:return_body) do
        '[{"TransactionNumber":123456, "Username":"test123", "RequestType":"Loan", "LoanAuthor":"Author, Test", 
          "LoanTitle":"The Book Title", "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"},
          {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan", "LoanAuthor":"Author, Test", 
            "LoanTitle":"The Book Title", "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"}]'
      end

      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/UserRequests/" \
                            "test123?$filter=(RequestType%20eq%20'Loan')%20and%20((Transaction" \
                            "Status%20eq%20'Checked%20Out%20to%20Customer')%20or%20(startswith" \
                            "(%20TransactionStatus,%20'Renewed%20by')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 200, body: return_body)
      end

      it 'returns an array of loan checkouts' do
        expect(get_loan_checkouts_response.count).to eq 2
        expect(get_loan_checkouts_response.first.title).to eq 'The Book Title'
      end
    end

    context 'when getting loan checkouts is unsuccessful' do
      before do
        stub_request(:get, "#{Settings.illiad.url}/ILLiadWebPlatform/Transaction/UserRequests/" \
                            "test123?$filter=(RequestType%20eq%20'Loan')%20and%20((Transaction" \
                            "Status%20eq%20'Checked%20Out%20to%20Customer')%20or%20(startswith" \
                            "(%20TransactionStatus,%20'Renewed%20by')))")
          .with(body: nil,
                headers: { 'Content-Type': 'application/json', 'ApiKey': Settings.illiad.api_key })
          .to_return(status: 400, body: '400 Error')
      end

      it 'returns an error' do
        expect{ get_loan_checkouts_response }.to raise_error(RuntimeError, '400 Error')
      end
    end
  end
end
