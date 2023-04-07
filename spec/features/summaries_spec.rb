# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Summaries' do
  let(:headers) { {
    'Apikey' => '1234',
    'Connection' => 'close',
    'Content-Type' => 'application/json',
    'Host' => 'illiad.illiad',
    'User-Agent' => 'http.rb/4.4.1'
  } }

  after do
    Warden::Manager._on_request.clear
  end

  describe 'the summaries page', js: true do
    context 'when there are no ILLiad checkouts or holds' do
      let(:mock_user) { 'patron1' }
      let(:return_body) { '[]' }

      before do
        stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
          .with(headers:)
          .to_return(status: 200, body: return_body, headers: {})
        login_permanently_as username: 'PATRON1', patron_key: mock_user
      end

      it 'is accessible' do
        visit summaries_path

        expect(page).to be_accessible
      end
    end

    context 'when a user has two ILLiad checkouts' do
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
      # patron2 below has 2 checkouts (1 recalled, 1 overdue) and no holds
      let(:mock_user2) { 'patron2' }
      let(:hold) {
        'ILLiadWebPlatform/Transaction/UserRequests/PATRON2?$filter=%28RequestType+eq+%27Loan%27%29+and+%28' \
          'TransactionStatus+eq+%27Awaiting+Copyright+Clearance%27+or+TransactionStatus+eq+%27Awaiting+Request' \
          '+Processing%27+or+TransactionStatus+eq+%27Awaiting+Account+Validation%27+or+TransactionStatus+eq+%27' \
          'In+Depth+Searching%27+or+TransactionStatus+eq+%27Awaiting+Reshare+Search%27+or+TransactionStatus+eq' \
          '+%27UBorrow+Find+Item+Search%27+or+TransactionStatus+eq+%27Awaiting+RAPID+Request+Sending%27+or+' \
          'TransactionStatus+eq+%27Awaiting+Post+Receipt+Processing%27+or+TransactionStatus+eq+%27Request+Sent' \
          '%27+or+TransactionStatus+eq+%27In+Transit+to+Pickup+Location%27+or+TransactionStatus+eq+%27Customer+' \
          'Notified+via+E-Mail%27+or+TransactionStatus+eq+%27Cancelled+by+Customer%27+or+TransactionStatus+eq+' \
          '%27Duplicate+Request+Review%27+or+TransactionStatus+eq+%27Request+Available+Locally%27+or+' \
          'TransactionStatus+eq+%27LST+TESTING%27or+%28startswith%28+TransactionStatus%2C+%27STAFF%27%29%29%29' }
      let(:checkout) {
        'ILLiadWebPlatform/Transaction/UserRequests/PATRON2?$filter=%28RequestType+eq+%27Loan%27%29+and+%28%28' \
          'TransactionStatus+eq+%27Checked+Out+to+Customer%27%29+or+%28TransactionStatus+eq+%27Awaiting+Recalled' \
          '+Processing%27%29+or+%28TransactionStatus+eq+%27LST+TESTING%27%29+or+%28startswith%28+' \
          'TransactionStatus%2C+%27Renewed+by%27%29%29%29' }

      before do
        stub_request(:get, "https://illiad.illiad/illiad/#{hold}")
          .with(headers:)
          .to_return(status: 200, body: hold_return_body, headers: {})
        stub_request(:get, "https://illiad.illiad/illiad/#{checkout}")
          .with(headers:)
          .to_return(status: 200, body: checkout_return_body, headers: {})
        login_permanently_as username: 'PATRON2', patron_key: mock_user2
      end

      it 'includes Illiad materials in the summary counts' do
        visit summaries_path
        expect(page).to have_content 'Total checked out 5'
        expect(page).to have_content '2 recalled'
        expect(page).to have_content '3 overdue'
        expect(page).to have_content 'Total holds 2'
        expect(page).to have_content '1 ready for pickup'
        expect(page).to have_content '1 not yet ready for pickup'
      end
    end
  end
end
