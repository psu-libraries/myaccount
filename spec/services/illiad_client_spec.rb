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
end
