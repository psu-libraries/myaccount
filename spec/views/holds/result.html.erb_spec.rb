# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'holds/result.html.erb', type: :view do
  let(:placed_hold) { build(:hold) }
  let(:failed_hold) { build(:item) }
  let(:results) { {
    success: [{ placed_hold: placed_hold,
                barcode: 'holdable_barcode',
                hold_key: 'a_hold_key' }],
    error: [{ failed_hold: failed_hold,
              barcode: 'not_holdable_barcode',
              error_message: 'User already has a hold on this material' }]
  }.with_indifferent_access }
  let(:mock_patron) { instance_double(Patron, display_name: 'Somebody') }

  before do
    controller.singleton_class.class_eval do
      protected

        def patron; end

        helper_method :patron
    end

    allow(view).to receive(:patron).and_return(mock_patron)

    assign(:place_hold_results, results)
    assign(:place_hold_catkey, '1')
    allow(placed_hold).to receive(:item_type_mapping).and_return(ITEM_TYPE_MAPPING)
    allow(failed_hold).to receive(:item_type_mapping).and_return(ITEM_TYPE_MAPPING)
  end

  context 'with placed hold(s)' do
    before do
      placed_hold.record['fields']['bib']['fields']['title'] = 'A wonderful title'
      placed_hold.record['fields']['bib']['fields']['author'] = 'A wonderful author'
      placed_hold.record['fields']['item']['fields']['itemType']['key'] = 'ATLAS'
      placed_hold.record['fields']['bib']['key'] = '1'
      placed_hold.record['fields']['item']['fields']['call']['fields']['dispCallNumber'] = 'ABC 123'
      placed_hold.record['fields']['pickupLibrary']['key'] = 'UP-PAT'
      placed_hold.record['fields']['fillByDate'] = '2020-01-17'
    end

    it 'displays the linked hold title' do
      render

      expect(rendered).to have_link('A wonderful title / A wonderful author',
                                    href: 'https://catalog.libraries.psu.edu/catalog/1')
    end

    it 'displays the format and call number of the placed hold' do
      render

      expect(rendered).to have_content /Atlas: ABC 123/
    end

    it 'displays the pickup location' do
      render

      expect(rendered).to have_content /Pickup at: Pattee Library and Paterno Library Stacks/
    end

    it 'displays the not needed after date' do
      render

      expect(rendered).to have_content /Not needed after: January 17, 2020/
    end
  end

  context 'with failed hold(s)' do
    before do
      failed_hold.record['fields']['bib']['fields']['title'] = 'Another title'
      failed_hold.record['fields']['bib']['fields']['author'] = 'Another author'
      failed_hold.record['fields']['itemType']['key'] = 'BOOK'
      failed_hold.record['fields']['bib']['key'] = '2'
      failed_hold.record['fields']['call']['fields']['dispCallNumber'] = 'DEF 456'
    end

    it 'displays the linked item title' do
      render

      expect(rendered).to have_link('Another title / Another author',
                                    href: 'https://catalog.libraries.psu.edu/catalog/2')
    end

    it 'displays the format and call number of the failed hold' do
      render

      expect(rendered).to have_content /Book: DEF 456/
    end

    it 'displays the error message' do
      render

      expect(rendered).to have_content /User already has a hold on this material/
    end
  end
end
