# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'checkouts/index.html.erb', type: :view do
  context 'when user has checkout(s)' do
    let(:checkout) { build(:checkout) }

    before do
      assign(:checkouts, [checkout])
      allow(checkout).to receive(:item_type_mapping).and_return(ITEM_TYPE_MAPPING)
    end

    it 'displays total checked out correctly' do
      render
      expect(rendered).to include 'Total Checked Out: 1'
    end

    it 'displays total # of recalled items correctly' do
      checkout.record['fields']['recalledDate'] = '2019-12-10'
      render
      expect(rendered).to include 'Recalled: 1'
    end

    it 'displays total # of overdue items correctly' do
      checkout.record['fields']['overdue'] = true
      render
      expect(rendered).to include 'Overdue: 1'
    end

    it 'displays a checkout for renewal' do
      checkout.record['fields']['item']['key'] = '7777247:1:1'
      render
      expect(rendered).to include '<input type="checkbox" name="renewal_list[]" id="renewal_list__7777247:1:1" '\
                                  'value="7777247:1:1" data-select-all-target="renewal" class="checkbox" '\
                                  'multiple="multiple" />'
    end

    it 'displays checkout\'s item\'s title / author' do
      checkout.record['fields']['item']['fields']['bib']['fields']['title'] = 'A wonderful title'
      checkout.record['fields']['item']['fields']['bib']['fields']['author'] = 'A wonderful author'
      render
      expect(rendered).to include 'A wonderful title / A wonderful author'
    end

    it 'displays call number correctly' do
      checkout.record['fields']['item']['fields']['call']['fields']['dispCallNumber'] = 'A very cool call number'
      render
      expect(rendered).to include 'A very cool call number'
    end

    it 'displays checkout\'s item\'s canonical item link' do
      checkout.record['fields']['item']['fields']['bib']['key'] = '123456'
      render
      expect(rendered).to include 'catalog.libraries.psu.edu/catalog/123456'
    end

    it 'displays checkout\'s item\'s item type' do
      checkout.record['fields']['item']['fields']['itemType']['key'] = 'PERIODICAL'
      render
      expect(rendered).to include 'Bound Journal'
    end

    it 'displays checkout\'s renewal count' do
      checkout.record['fields']['renewalCount'] = 2
      render
      expect(rendered).to include '<td class="renewal_count">2</td>'
    end

    it 'displays checkout\'s due date correctly when not recalled' do
      checkout.record['fields']['dueDate'] = '2019-11-14T23:59:00-05:00'
      checkout.record['fields']['recalledDate'] = nil
      render
      expect(rendered).to include 'November 14, 2019'
    end

    it 'displays checkout\'s due date correctly when recalled' do
      checkout.record['fields']['dueDate'] = '2019-11-14T23:59:00-05:00'
      checkout.record['fields']['recallDueDate'] = '2019-12-20T22:30:00-05:00'
      render
      expect(rendered).to include 'Recalled&lt;br&gt;December 20, 2019 10:30pm&lt;br&gt;November 14, 2019'
    end

    it 'displays checkout\'s status correctly when overdue' do
      checkout.record['fields']['overdue'] = true
      render
      expect(rendered).to include 'Overdue'
    end

    it 'displays checkout\'s status correctly when claims returned' do
      checkout.record['fields']['overdue'] = true
      checkout.record['fields']['claimsReturnedDate'] = '2019-11-01'
      render
      expect(rendered).to include 'Claims Returned'
    end

    it 'displays checkout\'s estimated overdue amount when item is overdue' do
      checkout.record['fields']['estimatedOverdueAmount']['amount'] = '10.00'
      render
      expect(rendered).to include '$10.00'
    end

    it 'displays a renew button' do
      render
      renew_button = '<input type="submit" name="commit" value="Renew" class="btn btn-primary" '\
                     'data-disable-with="Please wait..." />'
      expect(rendered).to include renew_button
    end

    it 'displays a renew all select' do
      render
      expect(rendered).to have_unchecked_field 'renewal_list__24053411:3:1'
    end
  end
end
