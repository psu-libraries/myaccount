# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Holds' do
  let(:mock_user) { 'patron1' }

  after do
    Warden::Manager._on_request.clear
    Redis.current.flushall
  end

  context 'when patron1 has 1 hold ready for pick and 4 holds not yet ready for pickup' do
    before do
      stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
        .with(
          headers: {
            'Apikey' => '1234',
            'Connection' => 'close',
            'Content-Type' => 'application/json',
            'Host' => 'illiad.illiad',
            'User-Agent' => 'http.rb/5.2.0'
          }
        )
        .to_return(status: 200, body: '[]', headers: {})
      login_permanently_as username: 'PATRON1', patron_key: mock_user
      visit holds_path
    end

    context 'when a patron has some holds not yet ready to pickup (i.e., pending)' do
      context 'when visiting the checkouts page', :js do
        it 'displays accessible holds section' do
          expect(page).to be_accessible
          expect(page).to have_css 'h1', text: 'Holds'
          expect(page).to have_no_content 'Interlibrary Loan Requests'
        end
      end

      describe 'change_pickup_library' do
        before do
          page.check 'hold_list__3911148'
          page.select 'Penn State York', from: 'pickup_library'
          page.click_on 'Update Selected Holds'
        end

        it 'lets the user change the pickup library of a hold', :js do
          expect(page).to have_css '.bg-success', text: 'Successfully changed pickup location'
          expect(page).to have_css '#hold3911148 .pickup_at', text: 'York'
          expect(page).to have_unchecked_field 'hold_list__3911148'
        end

        context 'when the user successfully changes the pickup library of the same hold more than once' do
          xit 'success badges gets cleared each time', :js do
            page.find("input[type='checkbox'][id='hold_list__3911148']").click
            page.select 'Berks Campus Library', from: 'pickup_library'
            page.click_on 'Update Selected Holds'

            expect(page.find('.bg-success')).to have_text 'Successfully changed pickup location', count: 1
          end
        end
      end

      describe 'change_pickup_by_date' do
        before do
          page.check 'hold_list__3911148'
          page.fill_in 'pickup_by_date', with: '01-01-9999'
          page.click_on 'Update Selected Holds'
          page.find('#hold3911148 .pickup-by', text: 'January 1, 9999')
        end

        it 'lets the user change the pickup by date of a hold', :js do
          expect(page).to have_css '.bg-success', text: 'Successfully updated pickup by date'
          expect(page).to have_css '#hold3911148 .pickup-by', text: 'January 1, 9999'
          expect(page).to have_unchecked_field 'hold_list__3911148'
        end

        context 'when the user successfully changes the pickup up by date of the same hold more than once' do
          it 'success badges gets cleared each time', :js do
            page.check 'hold_list__3911148'
            page.fill_in 'pickup_by_date', with: '01-01-2020'
            page.click_on 'Update Selected Holds'

            expect(page.find('.bg-success')).to have_text 'Successfully updated pickup by date', count: 1
          end
        end
      end

      it 'lets the user cancel a pending hold', :js do
        page.check 'hold_list__3911148'
        element = find('input[type="submit"][value="Cancel"]', visible: true, wait: 5)
        page.execute_script('arguments[0].scrollIntoView({ behavior: "instant", block: "center" });', element)
        element.click
        expect(page).to have_css '#hold3911148 .hold_status', text: 'Canceled'
        expect(page).to have_css '.bg-success', text: 'Hold canceled'
        expect(page).to have_unchecked_field 'hold_list__3911148'
      end

      it 'lets the user cancel a ready for pickup hold', :js do
        page.check 'hold_list__3906718'
        page.click_on 'Cancel Selected Holds'
        expect(page).to have_css '#hold3906718 .hold_status', text: 'Canceled'
        expect(page).to have_css '.bg-success', text: 'Hold canceled'
        expect(page).to have_unchecked_field 'hold_list__3911148'
      end
    end

    context 'when a patron attempts to create a hold for a monograph', :js do
      before do
        visit '/holds/new?catkey=6066288'
      end

      it 'is accessible', :js do
        expect(page).to be_accessible
      end

      it 'renders a form for the item being requested' do
        expect(page).to have_text 'Title: 13 bankers : the Wall Street takeover and the next financial meltdown'
      end

      it 'allows user to place a hold for a holdable item', :js do
        select 'College of Medicine (Hershey)', from: 'pickup_library'
        fill_in 'pickup_by_date', with: '10-10-2050'

        page.click_on 'Place Hold'
        expect(page).to have_text 'Hold Placed'
      end

      it 'displays Back To Catalog link with the catkey', :js do
        select 'College of Medicine (Hershey)', from: 'pickup_library'
        fill_in 'pickup_by_date', with: '10-10-2050'

        page.click_on 'Place Hold'
        expect(page).to have_link 'Back to Catalog', href: 'https://catalog.libraries.psu.edu/catalog/6066288'
      end

      context 'when patron uses browser back button to place hold result page' do
        it 'redirects to 404', :js do
          select 'College of Medicine (Hershey)', from: 'pickup_library'
          fill_in 'pickup_by_date', with: '10-10-2050'

          page.click_on 'Place Hold'
          expect(page).to have_text 'Hold Placed'
          visit summaries_path
          page.go_back

          expect(page).to have_current_path('/not_found')
        end
      end
    end

    context 'when patron uses browser back button to holds page' do
      it 'forces checkout page to reload', :js do
        visit holds_path
        visit summaries_path
        page.go_back
        expect(page).to have_css '#hold3911148'
      end
    end

    context 'when site is in maintenance mode' do
      after do
        Settings.maintenance_mode = false
      end

      it 'removes the checkboxes and hold cancellation buttons', :js do
        Settings.maintenance_mode = true

        visit holds_path

        expect(page).to have_no_unchecked_field '.checkbox'
        expect(page).to have_no_button 'Cancel'
        expect(page).to have_no_button 'Cancel Selected Holds'
      end
    end
  end

  context 'when patron1 has 2 Interlibrary Loan Requests' do
    let(:return_body) do
      '[{"TransactionNumber":123456, "Username":"test123", "RequestType":"Loan",
         "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 1",
         "LoanPublisher":null, "LoanPlace":null, "TransactionStatus":"Awaiting Request Processing"},
        {"TransactionNumber":123457, "Username":"test123", "RequestType":"Loan",
         "LoanAuthor":"Author, Test", "LoanTitle":"The Book Title 2", "LoanPublisher":null,
         "LoanPlace":null, "TransactionStatus":"Request Sent"}]'
    end

    before do
      stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
        .with(
          headers: {
            'Apikey' => '1234',
            'Connection' => 'close',
            'Content-Type' => 'application/json',
            'Host' => 'illiad.illiad',
            'User-Agent' => 'http.rb/5.2.0'
          }
        )
        .to_return(status: 200, body: return_body, headers: {})
      login_permanently_as username: 'PATRON1', patron_key: mock_user
      visit holds_path
    end

    context 'when visiting the holds page', :js do
      it 'displays accessible Interlibrary Loan Requests section' do
        expect(page).to be_accessible
        expect(page).to have_content 'Interlibrary Loan Requests'
        expect(page).to have_content 'The Book Title 1'
        expect(page).to have_content 'The Book Title 2'
        expect(page).to have_link 'Manage your Interlibrary Loan Request',
                                  href: I18n.t('myaccount.ill.manage_url', library: 'upm')
        expect(page).to have_content 'Author'
        expect(page).to have_content 'Creation Date'
        expect(page).to have_content 'Status'
      end
    end
  end
end
