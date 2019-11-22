# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patron, type: :model do
  subject do
    described_class.new(
      {
        key: '1',
        fields: fields
      }.with_indifferent_access
    )
  end

  let(:fields) do
    {
      firstName: 'Student',
      lastName: 'Borrower',
      barcode: '1234'
    }
  end

  it 'has a key' do
    expect(subject.key).to eq '1'
  end

  it 'has a first name' do
    expect(subject.first_name).to eq 'Student'
  end

  it 'has a last name' do
    expect(subject.last_name).to eq 'Borrower'
  end

  it 'has a display name' do
    expect(subject.display_name).to eq 'Student Borrower'
  end

  it 'has a barcode' do
    expect(subject.barcode).to eq '1234'
  end

  context 'with checkouts' do
    before do
      fields[:circRecordList] = [{ key: 1, fields: {} }]
    end

    describe '#checkouts' do
      it 'returns a list of checkouts for the patron' do
        expect(subject.checkouts).to include a_kind_of(Checkout).and(have_attributes(key: 1))
      end
    end
  end

  context 'with holds' do
    before do
      fields[:holdRecordList] = [{ key: 1, fields: {} }]
    end

    describe '#holds' do
      it 'returns a list of holds for the patron' do
        expect(subject.holds).to include a_kind_of(Hold).and(have_attributes(key: 1))
      end
    end
  end
end
