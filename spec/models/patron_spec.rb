# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patron do
  subject(:patron) { described_class.new(record) }

  let(:record) do
    {
      key: '1',
      fields:
    }.with_indifferent_access
  end

  let(:fields) do
    {
      alternateID: 'TEST123',
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
      profile: {
        key: 'STAFF'
      },
      customInformation: [
        {
          resource: '/user/patron/customInformation',
          key: '1',
          fields: {
            code: {
              resource: '/policy/patronExtendedInformation',
              key: 'PSUACCOUNT'
            },
            data: '20050801'
          }
        },
        {
          resource: '/user/patron/customInformation',
          key: '19',
          fields: {
            code: {
              resource: '/policy/patronExtendedInformation',
              key: 'GARNISH-DT'
            },
            data: '00000000'
          }
        }
      ]
    }
  end

  it 'has an alternate id' do
    expect(patron.id).to eq 'test123'
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

  it 'has a suffix' do
    expect(patron.suffix).to eq 'Jr'
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

  it 'has a garnish date' do
    expect(patron.garnish_date).to eq '00000000'
  end

  it 'has the correct faculty/staff status' do
    expect(patron.faculty_or_staff?).to be true
  end

  it 'has the correct wage garnishment eligibility status' do
    expect(patron.eligible_for_wage_garnishment?).to be true
  end

  context 'with checkouts' do
    before { fields[:circRecordList] = [{ key: 1, fields: { status: 'ACTIVE' } }] }

    describe '#checkouts' do
      it 'returns a list of checkouts for the patron' do
        expect(patron.checkouts).to include a_kind_of(Checkout).and(have_attributes(key: 1))
      end
    end
  end

  context 'with holds' do
    before { fields[:holdRecordList] = [{ key: 1, fields: {} }] }

    describe '#holds' do
      it 'returns a list of holds for the patron' do
        expect(patron.holds).to include a_kind_of(Hold).and(have_attributes(key: 1))
      end
    end
  end

  context 'with fines' do
    before { fields[:blockList] = [{ key: 1, fields: {} }] }

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

  describe '#ill_ineligible?' do
    context 'when a patron profile is elligible for ILLiad' do
      it 'returns false' do
        expect(patron.ill_ineligible?).to be false
      end
    end

    context 'when a patron profile is not elligible for ILLiad' do
      before { fields[:profile] = { key: 'ALUMNI' } }

      it 'returns true' do
        expect(patron.ill_ineligible?).to be true
      end
    end
  end

  describe '#ill_blocked?' do
    context 'when a patrons ILLiad clearance allows them to place an ILLiad hold' do
      before {
 allow(IlliadClient).to receive_message_chain(:new,
                                              :get_user_info).and_return({ 'UserName' => 'test123',
                                                                           'Cleared' => 'Yes' }) }

      it 'returns false' do
        expect(patron.ill_blocked?).to be false
      end
    end

    context 'when a patrons ILLiad clearance does not allow them to place an ILLiad hold' do
      before {
 allow(IlliadClient).to receive_message_chain(:new,
                                              :get_user_info).and_return({ 'UserName' => 'test123',
                                                                           'Cleared' => 'DIS' }) }

      it 'returns true' do
        expect(patron.ill_blocked?).to be true
      end
    end
  end
end
