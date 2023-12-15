# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkouts' do
  let(:mock_user) { 'patron2' }

  after do
    Warden::Manager._on_request.clear
    Redis.current.flushall
  end

  context 'when patron2 has 2 checkouts and no Interlibrary Loan Checkouts' do
    before do
      stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
        .with(
          headers: {
            'Apikey' => '1234',
            'Connection' => 'close',
            'Content-Type' => 'application/json',
            'Host' => 'illiad.illiad',
            'User-Agent' => 'http.rb/4.4.1'
          }
        )
        .to_return(status: 200, body: '[]', headers: {})
      login_permanently_as username: 'PATRON2', patron_key: mock_user
      visit checkouts_path
    end

    context 'when visiting the checkouts page', js: true do
      it 'displays accessible checkouts section' do
        expect(page).to be_accessible
        expect(page).to have_content 'Checkouts/Renewals'
        expect(page).to have_link 'Download all as RIS', href: 'https://catalog.k8s.libraries.psu.edu/bookmarks/bulk_ris/2145643,3591032'
        expect(page).not_to have_content 'Interlibrary Loan Checkouts'
      end
    end

    context 'when patron renews a checkout successfully', js: true do
      before do
        page.check 'renewal_list__2145643:5:1'
        page.click_button 'Renew', match: :first
      end

      it 'adds a success badge' do
        expect(page).to have_css '.badge-success', text: 'Successfully renewed'
      end

      it 'displays renewals summary' do
        expect(page).to have_css '.renewals-summary',
                                 text: "Renewals processing completed.\n1 successfully renewed\n0 failed to renew"
      end

      it 'updates the renewal count, due date and status' do
        expect(page).to have_css('[id="checkout2145643:5:1"] .renewal_count', text: '70')
          .and have_css('[id="checkout2145643:5:1"] .due-date', text: 'August 13, 2020')
          .and have_css '[id="checkout2145643:5:1"] .status', text: ''
      end

      context 'when renewing the same checkout successfully more than once' do
        it 'success badges gets cleared each time' do
          page.check 'renewal_list__2145643:5:1'
          page.click_button 'Renew', match: :first

          expect(page).to have_css '.badge-success', text: 'Successfully renewed', count: 1
        end
      end
    end

    context 'when patron fails to renew a checkout successfully', js: true do
      before do
        page.check 'renewal_list__3591032:1:1'
        page.click_button 'Renew', match: :first
      end

      it 'adds a badge for failed renewal' do
        expect(page).to have_css '.badge-danger', text: 'Failed to renew'
      end

      it 'generates an error message (a "toast")' do
        expect(page).to have_css('.toast')
      end

      it 'displays renewals summary' do
        expect(page).to have_css '.renewals-summary',
                                 text: "Renewals processing completed.\n0 successfully renewed\n1 failed to renew"
      end
    end

    context 'when patron uses browser back button to checkouts page' do
      it 'forces checkout page to reload', js: true do
        visit summaries_path
        page.go_back
        expect(page).to have_css '[id="checkout2145643:5:1"]'
      end
    end
  end

  context 'when patron2 has 2 checkouts and 2 Interlibrary Loan Checkouts' do
    let(:return_body) do
      '[{"TransactionNumber":123456, "Username":"test123", "RequestType":"Loan",
         "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 1",
         "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"},
        {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
          "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 2", "LoanPublisher":null,
          "LoanPlace":null, "TransactionStatus":"Checked Out to Customer"}]'
    end

    before do
      stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
        .with(
          headers: {
            'Apikey' => '1234',
            'Connection' => 'close',
            'Content-Type' => 'application/json',
            'Host' => 'illiad.illiad',
            'User-Agent' => 'http.rb/4.4.1'
          }
        )
        .to_return(status: 200, body: return_body, headers: {})
      login_permanently_as username: 'PATRON2', patron_key: mock_user
      visit checkouts_path
    end

    context 'when visiting the checkouts page', js: true do
      it 'displays accessible Interlibrary Loan Checkouts section' do
        expect(page).to be_accessible
        expect(page).to have_content 'Interlibrary Loan Checkouts'
        expect(page).to have_content 'The Book Title 1'
        expect(page).to have_content 'The Book Title 2'
        expect(page).to have_link 'Manage your Interlibrary Loans',
                                  href: I18n.t('myaccount.ill.manage_url', library: 'upm')
        expect(page).to have_link 'Download all as RIS', href: export_ill_ris_path
        expect(page).to have_content 'Author'
        expect(page).to have_content 'Due Date'
        expect(page).to have_content 'Status'
      end
    end
  end
end
