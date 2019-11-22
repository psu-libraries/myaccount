# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  subject do
    described_class.new({
      key: '1',
      fields: fields
    }.with_indifferent_access)
  end

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
    expect(subject.key).to eq '1'
  end

  it 'has a patron key' do
    expect(subject.patron_key).to eq '123'
  end

  it 'has a status' do
    expect(subject.status).to eq 'ACTIVE'
  end

  it 'has an overdue state' do
    expect(subject.overdue?).to be true
  end

  it 'does not have a recalled date' do
    expect(subject.recalled_date).to be_nil
  end

  it 'is not recalled' do
    expect(subject).not_to be_recalled
  end

  context 'with a record that has been recalled' do
    before do
      fields[:recalledDate] = '2019-07-11T13:59:00-07:00'
      fields[:recallDueDate] = '2019-08-11T13:59:00-07:00'
    end

    it 'has a recalled date' do
      expect(subject.recalled_date.strftime('%m/%d/%Y')).to eq '07/11/2019'
    end

    it 'is recalled' do
      expect(subject).to be_recalled
    end
  end

  it 'has a library' do
    expect(subject.library).to eq 'UP-PAT'
  end

  it 'has a title' do
    expect(subject.title).to eq 'Some Title'
  end

  it 'has an author' do
    expect(subject.author).to eq 'Somebody'
  end

  it 'has a call number' do
    expect(subject.call_number).to eq 'ABC 123'
  end

  it 'has a shelf key' do
    expect(subject.shelf_key).to eq 'ABC 00123'
  end

  it 'has a barcode' do
    expect(subject.barcode).to eq 'xyz'
  end

  it 'has a catkey' do
    expect(subject.catkey).to eq '123456'
  end

  it 'has a current location' do
    expect(subject.current_location).to eq 'CHECKEDOUT'
  end

  it 'is not lost' do
    expect(subject).not_to be_lost
  end
end
