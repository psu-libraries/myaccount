# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hold, type: :model do
  subject(:hold) do
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
    expect(hold.key).to eq '1'
  end

  it 'has a patron key' do
    expect(hold.patron_key).to eq '123'
  end

  it 'has a status' do
    expect(hold.status).to eq 'ACTIVE'
  end

  context 'when the item is ready for pickup' do
    before { fields[:status] = 'BEING_HELD' }

    it 'has a status' do
      expect(hold.status).to eq 'BEING_HELD'
    end
  end

  it 'has a placed library' do
    expect(hold.placed_library).to eq 'UP-PAT'
  end

  it 'has a pickup library' do
    expect(hold.pickup_library).to eq 'UP-PAT'
  end

  it 'has a title' do
    expect(hold.title).to eq 'Some Title'
  end

  it 'has an author' do
    expect(hold.author).to eq 'Somebody'
  end

  it 'has a catkey' do
    expect(hold.catkey).to eq '123456'
  end
end
