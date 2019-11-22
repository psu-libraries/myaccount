# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hold, type: :model do
  subject do
    described_class.new({
      key: '1',
      fields: fields
    }.with_indifferent_access)
  end

  let(:fields) do
    {
      status: 'ACTIVE',
      pickupLibrary: { key: 'UP-PAT' },
      placedLibrary: { key: 'UP-PAT' },
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

  context 'when the item is ready for pickup' do
    before { fields[:status] = 'BEING_HELD' }

    it 'has a status' do
      expect(subject.status).to eq 'BEING_HELD'
    end
  end

  it 'has a placed library' do
    expect(subject.placed_library).to eq 'UP-PAT'
  end

  it 'has a pickup library' do
    expect(subject.pickup_library).to eq 'UP-PAT'
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

  it 'has a catkey' do
    expect(subject.catkey).to eq '123456'
  end

  it 'has a barcode' do
    expect(subject.barcode).to eq 'xyz'
  end
end
