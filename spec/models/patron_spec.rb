# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patron do
  subject(:patron) { described_class.new(record) }

  let(:record) do
    {
      key: '1',
      fields: fields
    }.with_indifferent_access
  end

  let(:fields) do
    {
      firstName: 'Student',
      middleName: 'Person',
      lastName: 'Borrower',
      suffix: 'Jr',
      displayName: 'Borrower Jr, Student Person',
      barcode: '1234',
      standing: {
        key: 'OK'
      },
      library: {
        key: 'UP-PAT'
      },
      address1: [{ resource: '/user/patron/address1',
                   fields: { code: {
                     resource: '/policy/patronAddress1',
                     key: 'EMAIL'
                   }, data: 'zzz@example.com' } },
                 { resource: '/user/patron/address1',
                   fields: { code: {
                     resource: '/policy/patronAddress1',
                     key: 'STREET1'
                   }, data: '123 Fake Street' } },
                 { resource: '/user/patron/address1',
                   fields: { code: {
                     resource: '/policy/patronAddress1',
                     key: 'STREET2'
                   }, data: '' } },
                 { resource: '/user/patron/address1',
                   fields: { code: {
                     resource: '/policy/patronAddress1',
                     key: 'ZIP'
                   }, data: '00000' } },
                 { resource: '/user/patron/address1',
                   fields: { code: {
                     resource: '/policy/patronAddress1',
                     key: 'DAYPHONE'
                   }, data: '555-555-5555' } },
                 { resource: '/user/patron/address1',
                   fields: { code: {
                     resource: '/policy/patronAddress1',
                     key: 'PHONE'
                   }, data: '555-555-5555' } },
                 { resource: '/user/patron/address1',
                   fields: { code: {
                     resource: '/policy/patronAddress1',
                     key: 'CITY/STATE'
                   }, data: 'Jersey Shore, PA' } }]
    }
  end

  it 'has a key' do
    expect(patron.key).to eq '1'
  end

  it 'has a first name' do
    expect(patron.first_name).to eq 'Student'
  end

  it 'has a middle name' do
    expect(patron.middle_name).to eq 'Person'
  end

  it 'has a last name' do
    expect(patron.last_name).to eq 'Borrower'
  end

  it 'has a display name' do
    expect(patron.display_name).to eq 'Borrower Jr, Student Person'
  end

  it 'has a barcode' do
    expect(patron.barcode).to eq '1234'
  end

  it 'has a library' do
    expect(patron.library).to eq 'UP-PAT'
  end

  it 'has a email' do
    expect(patron.email).to eq 'zzz@example.com'
  end

  it 'has a city' do
    expect(patron.city).to eq 'Jersey Shore'
  end

  it 'has a state' do
    expect(patron.state).to eq 'PA'
  end

  it 'has a address' do
    expect(patron.address).to eq({ city_state: 'Jersey Shore, PA', street1: '123 Fake Street', street2: '',
                                   zip: '00000' })
  end

  context 'with checkouts' do
    before do
      fields[:circRecordList] = [{ key: 1, fields: { status: 'ACTIVE' } }]
    end

    describe '#checkouts' do
      it 'returns a list of checkouts for the patron' do
        expect(patron.checkouts).to include a_kind_of(Checkout).and(have_attributes(key: 1))
      end
    end
  end

  context 'with holds' do
    before do
      fields[:holdRecordList] = [{ key: 1, fields: {} }]
    end

    describe '#holds' do
      it 'returns a list of holds for the patron' do
        expect(patron.holds).to include a_kind_of(Hold).and(have_attributes(key: 1))
      end
    end
  end

  context 'with fines' do
    before do
      fields[:blockList] = [{ key: 1, fields: {} }]
    end

    describe '#fines' do
      it 'makes a new Fine' do
        expect(patron.fines).to include a_kind_of(Fine)
      end
    end
  end

  it 'has no patron standing alerts' do
    expect(patron.standing_human).to be_empty
  end

  context 'with a patron standing alert' do
    let(:fields) do
      {
        standing: { key: 'DELINQUENT' }
      }
    end

    it 'has a patron standing alert' do
      expect(patron.standing_human).to include 'DELINQUENT'
    end
  end
end
