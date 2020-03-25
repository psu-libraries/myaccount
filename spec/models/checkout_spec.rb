# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  subject(:checkout) { build(:checkout) }

  it 'has a key' do
    checkout.record['key'] = '1'
    expect(checkout.key).to eq '1'
  end

  it 'has a status' do
    checkout.record['fields']['status'] = 'ACTIVE'
    expect(checkout.status).to eq 'ACTIVE'
  end

  context 'with a record that has not been recalled' do
    before do
      checkout.record['fields']['dueDate'] = '2019-12-19T23:59:00-05:00'
      checkout.record['fields']['recalledDate'] = ''
      checkout.record['fields']['recallDueDate'] = ''
    end

    it 'has a due date' do
      expect(checkout.due_date.strftime('%m/%d/%Y')).to eq '12/19/2019'
    end

    it 'has no recalled date' do
      expect(checkout.recalled_date).to be_nil
    end

    it 'has no recall due date' do
      expect(checkout.recall_due_date).to be_nil
    end

    it 'is not recalled' do
      expect(checkout).not_to be_recalled
    end
  end

  context 'with a record that has been recalled' do
    before do
      checkout.record['fields']['dueDate'] = '2019-12-19T23:59:00-05:00'
      checkout.record['fields']['recalledDate'] = '2019-11-10'
      checkout.record['fields']['recallDueDate'] = '2019-11-20T23:59:00-05:00'
    end

    it 'has a due date' do
      expect(checkout.due_date.strftime('%m/%d/%Y')).to eq '12/19/2019'
    end

    it 'has a recalled date' do
      expect(checkout.recalled_date.strftime('%m/%d/%Y')).to eq '11/10/2019'
    end

    it 'has a recall due date' do
      expect(checkout.recall_due_date.strftime('%m/%d/%Y')).to eq '11/20/2019'
    end

    it 'is recalled' do
      expect(checkout).to be_recalled
    end
  end

  it 'is not claimed returned' do
    checkout.record['fields']['claimsReturnedDate'] = nil
    expect(checkout).not_to be_claims_returned
  end

  context 'with an item claimed returned' do
    it 'is claimed returned' do
      checkout.record['fields']['claimsReturnedDate'] = '2019-12-01'
      expect(checkout).to be_claims_returned
    end
  end

  context 'with a record that has been renewed' do
    it 'has a renewal count' do
      checkout.record['fields']['renewalCount'] = 2
      expect(checkout.renewal_count).to eq 2
    end
  end

  it 'has an overdue state' do
    checkout.record['fields']['overdue'] = true
    expect(checkout.overdue?).to be true
  end

  it 'has an accrued' do
    checkout.record['fields']['estimatedOverdueAmount']['amount'] = 10.00
    expect(checkout.accrued).to eq 10.00
  end

  it 'has zero renewal count' do
    checkout.record['fields']['renewalCount'] = 0
    expect(checkout.renewal_count).to eq 0
  end

  it 'has a title' do
    checkout.record['fields']['item']['fields']['bib']['fields']['title'] = 'Some Title'
    expect(checkout.title).to eq 'Some Title'
  end

  it 'has an author' do
    checkout.record['fields']['item']['fields']['bib']['fields']['author'] = 'Somebody'
    expect(checkout.author).to eq 'Somebody'
  end

  it 'has a catkey' do
    checkout.record['fields']['item']['fields']['bib']['key'] = '123456'
    expect(checkout.catkey).to eq '123456'
  end

  it 'has a callnumber' do
    checkout.record['fields']['item']['fields']['call']['fields']['dispCallNumber'] = 'ABC 123'
    expect(checkout.call_number).to eq 'ABC 123'
  end

  it 'has a resource' do
    checkout.record['fields']['item']['resource'] = '/catalog/item'
    expect(checkout.resource).to eq '/catalog/item'
  end

  it 'has no shadowed item' do
    checkout.record['fields']['item']['fields']['bib']['fields']['shadowed'] = false
    expect(checkout).not_to be_shadowed
  end

  context 'with a shadowed item' do
    it 'is shadowed' do
      checkout.record['fields']['item']['fields']['bib']['fields']['shadowed'] = true
      expect(checkout).to be_shadowed
    end
  end
end
