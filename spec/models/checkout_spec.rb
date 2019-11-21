# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout do
  subject do
    described_class.new({
      key: '1',
      fields: fields
    }.with_indifferent_access)
  end

  let(:checkout) { subject }
  let(:fields) do
    {
      status: 'ACTIVE',
      overdue: true,
      checkOutDate: '2019-07-08T21:28:00-07:00',
      dueDate: '2019-07-09T23:59:00-07:00',
      library: {
        key: 'UP-PAT'
      },
      patron: {
        key: '123'
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

  it 'has a patron key' do
    expect(checkout.patron_key).to eq '123'
  end

  it 'has a status' do
    expect(checkout.status).to eq 'ACTIVE'
  end

  it 'has an overdue state' do
    expect(checkout.overdue?).to be true
  end

  it 'does not have a recalled date' do
    expect(checkout.recalled_date).to be_nil
  end

  it 'is not recalled' do
    expect(checkout).not_to be_recalled
  end

  context 'with a record that has been recalled' do
    before do
      fields[:recalledDate] = '2019-07-11T13:59:00-07:00'
      fields[:recallDueDate] = '2019-08-11T13:59:00-07:00'
    end

    it 'has a recalled date' do
      expect(checkout.recalled_date.strftime('%m/%d/%Y')).to eq '07/11/2019'
    end

    it 'is recalled' do
      expect(checkout).to be_recalled
    end
  end

  it 'has a library' do
    expect(checkout.library).to eq 'UP-PAT'
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
