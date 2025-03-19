# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ill/result.html.erb' do
  let(:mock_patron) { instance_double(Patron) }
  let(:place_loan_result) { { catkey: '1' } }
  let(:bib_result) do
    {
      catkey: '1',
      title: 'Some Great Book',
      author: 'Great Author',
      shadowed: false
    }
  end

  before do
    allow(mock_patron).to receive_messages(display_name: 'Jane Doe', key: '12345', library_ill_path_key: 'upm')

    controller.singleton_class.class_eval do
      protected

        def patron; end

        helper_method :patron
    end

    without_partial_double_verification {
      allow(view).to receive(:patron).and_return(mock_patron)
    }

    assign(:place_loan_result, place_loan_result)
    assign(:bib, OpenStruct.new(bib_result))

    render
  end

  it 'shows the patron\'s name' do
    expect(rendered).to have_content 'Jane Doe'
  end

  it 'sets the patron\'s key' do
    expect(rendered).to have_css '[@data-patron-key="12345"]'
  end

  it 'renders a link to back to catalog' do
    expect(rendered).to have_link 'Back to Catalog', href: 'https://catalog.libraries.psu.edu/catalog/1'
  end

  it 'renders a link to Illiad requests' do
    expect(rendered).to have_link 'See all holds', href: holds_path
  end

  context 'when there is a successful loan result' do
    let(:place_loan_result) { { catkey: '1', success: success_result } }
    let(:success_result) do
      {
        bib: bib_result,
        issn: '1234567',
        not_wanted_after: '2022-11-01',
        accept_alternate_edition: true,
        accept_ebook: true
      }.with_indifferent_access
    end

    it 'renders success results' do
      expect(rendered).to have_css 'h3', text: '1 Interlibrary Loan Request Placed'
      expect(rendered).to have_link 'Some Great Book / Great Author',
                                    href: 'https://catalog.libraries.psu.edu/catalog/1'
      expect(rendered).to have_content 'ISSN: 1234567'
      expect(rendered).to have_content 'Not Needed After: November 01, 2022'
      expect(rendered).to have_content 'Accept Alternate Edition: Yes'
      expect(rendered).to have_content 'Accept ebook if available: Yes'
      expect(rendered).to have_content I18n.t('myaccount.ill.place_loan.success_html')
    end
  end

  context 'when there is a failed loan result' do
    let(:place_loan_result) { { catkey: '1', error: error_result } }
    let(:error_result) do
      {
        bib: bib_result,
        error_message: 'Failed loan'
      }.with_indifferent_access
    end

    context 'when user is not a "HERSHEY" user' do
      it 'renders success results' do
        expect(rendered).to have_css 'h3', text: 'Interlibrary Loan Request Failed'
        expect(rendered).to have_link 'Some Great Book / Great Author',
                                      href: 'https://catalog.libraries.psu.edu/catalog/1'
        expect(rendered).to have_content 'Failed loan'
        expect(rendered).to have_content strip_tags(I18n.t('myaccount.ill.place_loan.error_html', library: 'upm'))
      end
    end

    context 'when user is a "HERSHEY" user' do
      before do
        allow(mock_patron).to receive(:library_ill_path_key).and_return('mhy')
      end

      it 'renders success results' do
        expect(rendered).to have_css 'h3', text: 'Interlibrary Loan Request Failed'
        expect(rendered).to have_link 'Some Great Book / Great Author',
                                      href: 'https://catalog.libraries.psu.edu/catalog/1'
        expect(rendered).to have_content 'Failed loan'
        expect(rendered).to have_content strip_tags(I18n.t('myaccount.ill.place_loan.error_html', library: 'mhy'))
      end
    end
  end
end
