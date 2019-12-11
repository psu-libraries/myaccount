# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  subject(:checkout) do
    described_class.new({
      key: '1',
      fields: fields
    }.with_indifferent_access)
  end

  let(:fields) do
    {
      status: 'ACTIVE',
      overdue: true,
      dueDate: '2019-12-19T23:59:00-05:00',
      estimatedOverdueAmount: {
        amount: '10.00',
        currencyCode: 'USD'
      },
      item: {
        fields: {
          barcode: 'xyz',
          currentLocation: { key: 'CHECKEDOUT' },
          bib: {
            key: '123456',
            fields: {
              title: 'Some Title',
              author: 'Somebody'
            }
          },
          call: {
            fields: {
              dispCallNumber: 'ABC 123',
              sortCallNumber: 'ABC 00123'
            }
          }
        }
      }
    }
  end

  it 'has a key' do
    expect(checkout.key).to eq '1'
  end

  it 'has a status' do
    expect(checkout.status).to eq 'ACTIVE'
  end

  context 'with a record that has not been recalled' do
    it 'has an original due date' do
      expect(checkout.original_due_date.strftime('%m/%d/%Y')).to eq '12/19/2019'
    end

    it 'has no recalled date' do
      expect(checkout.recalled_date).to be_nil
    end

    it 'has no recall due date' do
      expect(checkout.recall_due_date).to be_nil
    end

    it 'has a due date' do
      expect(checkout.due_date.strftime('%m/%d/%Y')).to eq '12/19/2019'
    end

    it 'is not recalled' do
      expect(checkout).not_to be_recalled
    end
  end

  context 'with a record that has been recalled' do
    before do
      fields[:recalledDate] = '2019-11-10'
      fields[:recallDueDate] = '2019-11-20T23:59:00-05:00'
    end

    it 'has an original due date' do
      expect(checkout.original_due_date.strftime('%m/%d/%Y')).to eq '12/19/2019'
    end

    it 'has a recalled date' do
      expect(checkout.recalled_date.strftime('%m/%d/%Y')).to eq '11/10/2019'
    end

    it 'has a recall due date' do
      expect(checkout.recall_due_date.strftime('%m/%d/%Y')).to eq '11/20/2019'
    end

    it 'has a due date' do
      expect(checkout.due_date.strftime('%m/%d/%Y')).to eq '11/20/2019'
    end

    it 'is recalled' do
      expect(checkout).to be_recalled
    end
  end

  it 'has an overdue state' do
    expect(checkout.overdue?).to be true
  end

  it 'has an accrued' do
    expect(checkout.accrued).to eq 10.00
  end

  it 'has a title' do
    expect(checkout.title).to eq 'Some Title'
  end

  it 'has an author' do
    expect(checkout.author).to eq 'Somebody'
  end

  it 'has a call number' do
    expect(checkout.call_number).to eq 'ABC 123'
  end

  it 'has a shelf key' do
    expect(checkout.shelf_key).to eq 'ABC 00123'
  end

  it 'has a barcode' do
    expect(checkout.barcode).to eq 'xyz'
  end

  it 'has a catkey' do
    expect(checkout.catkey).to eq '123456'
  end

  it 'has a current location' do
    expect(checkout.current_location).to eq 'CHECKEDOUT'
  end

  it 'is not lost' do
    expect(checkout).not_to be_lost
  end
end
