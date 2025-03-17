# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IlliadResponse do
  subject(:response) { described_class.new('PATRON2') }

  let(:hold_return_body) do
    '[{"TransactionNumber":123456, "Username":"test123", "RequestType":"Loan",
        "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 4",
        "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Awaiting Request Processing"},
      {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
        "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 5", "LoanPublisher":null,
        "LoanPlace":null, "TransactionStatus":"Customer Notified via E-Mail"}]'
  end
  let(:checkout_return_body) do
    '[{"TransactionNumber":123456, "Username":"test123", "RequestType":"Loan",
       "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 1",
       "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"},
      {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
        "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 2", "LoanPublisher":null,
        "LoanPlace":null, "TransactionStatus":"Awaiting Recalled Processing", "DueDate":"2023-02-28T00:00:00"},
      {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
        "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 3", "LoanPublisher":null,
        "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"}]'
  end
  let(:hold) {
    'ILLiadWebPlatform/Transaction/UserRequests/PATRON2?$filter=%28RequestType+eq+%27Loan%27%29+and+%28' \
      'TransactionStatus+eq+%27Awaiting+Copyright+Clearance%27+or+TransactionStatus+eq+%27Awaiting+Request' \
      '+Processing%27+or+TransactionStatus+eq+%27Awaiting+Account+Validation%27+or+TransactionStatus+eq+%27' \
      'In+Depth+Searching%27+or+TransactionStatus+eq+%27Awaiting+Reshare+Search%27+or+TransactionStatus+eq' \
      '+%27UBorrow+Find+Item+Search%27+or+TransactionStatus+eq+%27Awaiting+RAPID+Request+Sending%27+or+' \
      'TransactionStatus+eq+%27Awaiting+Post+Receipt+Processing%27+or+TransactionStatus+eq+%27Request+Sent' \
      '%27+or+TransactionStatus+eq+%27In+Transit+to+Pickup+Location%27+or+TransactionStatus+eq+%27Customer+' \
      'Notified+via+E-Mail%27+or+TransactionStatus+eq+%27Cancelled+by+Customer%27+or+TransactionStatus+eq+' \
      '%27Duplicate+Request+Review%27+or+TransactionStatus+eq+%27Request+Available+Locally%27+or+Transacti' \
      'onStatus+eq+%27Pattee+Notices%27+or+TransactionStatus+eq+%27LST+TESTING%27or+%28startswith%28+Trans' \
      'actionStatus%2C+%27STAFF%27%29%29%29' }
  let(:checkout) {
    'ILLiadWebPlatform/Transaction/UserRequests/PATRON2?$filter=%28RequestType+eq+%27Loan%27%29+and+%28%28' \
      'TransactionStatus+eq+%27Checked+Out+to+Customer%27%29+or+%28TransactionStatus+eq+%27Awaiting+Recalled' \
      '+Processing%27%29+or+%28TransactionStatus+eq+%27LST+TESTING%27%29+or+%28startswith%28+' \
      'TransactionStatus%2C+%27Renewed+by%27%29%29%29' }
  let(:headers) { {
    'Apikey' => '1234',
    'Connection' => 'close',
    'Content-Type' => 'application/json',
    'Host' => 'illiad.illiad',
    'User-Agent' => 'http.rb/5.2.0'
  } }

  before do
    stub_request(:get, "https://illiad.illiad/illiad/#{hold}")
      .with(headers:)
      .to_return(status: 200, body: hold_return_body, headers: {})
    stub_request(:get, "https://illiad.illiad/illiad/#{checkout}")
      .with(headers:)
      .to_return(status: 200, body: checkout_return_body, headers: {})
  end

  describe '#illiad_holds' do
    context 'when there are no holds found' do
      before do
        stub_request(:get, "https://illiad.illiad/illiad/#{hold}")
          .with(headers:)
          .to_return(status: 200, body: '[]', headers: {})
      end

      it 'returns an empty array' do
        expect(response.illiad_holds).to eq []
      end
    end

    context 'when there are holds found' do
      it 'returns two holds' do
        expect(response.illiad_holds.count).to eq 2
      end
    end
  end

  describe '#illiad_checkouts' do
    context 'when there are no checkouts found' do
      before do
        stub_request(:get, "https://illiad.illiad/illiad/#{checkout}")
          .with(headers:)
          .to_return(status: 200, body: '[]', headers: {})
      end

      it 'returns an empty array' do
        expect(response.illiad_checkouts).to eq []
      end
    end

    context 'when there are checkouts found' do
      it 'returns three checkouts' do
        expect(response.illiad_checkouts.count).to eq 3
      end
    end
  end

  describe '#ill_recalled' do
    it 'returns the number of recalled checkouts' do
      expect(response.ill_recalled).to eq 1
    end
  end

  describe '#ill_overdue' do
    it 'returns the number of overdue checkouts' do
      expect(response.ill_overdue).to eq 1
    end
  end

  describe '#ill_ready_for_pickup' do
    it 'returns the number of holds ready for pickup' do
      expect(response.ill_ready_for_pickup).to eq 1
    end
  end
end
