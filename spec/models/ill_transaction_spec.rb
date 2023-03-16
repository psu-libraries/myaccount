# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IllTransaction do
  let(:ill_transaction) { build(:ill_transaction_with_isbn) }

  it 'has a request type' do
    expect(ill_transaction.request_type).to be 'Loan'
  end

  it 'has a process type' do
    expect(ill_transaction.process_type).to be 'Borrowing'
  end

  it 'has an author' do
    expect(ill_transaction.loan_author).to be 'Hill Street blues (Television program)'
  end

  it 'has an publisher' do
    expect(ill_transaction.loan_publisher).to be 'ThingsBox'
  end

  it 'has a date' do
    expect(ill_transaction.loan_date).to be '1983'
  end

  it 'has a place' do
    expect(ill_transaction.loan_place).to be 'Tree House Inc'
  end

  it 'has a title' do
    expect(ill_transaction.loan_title).to be 'Hill Street blues. The complete series'
  end

  it 'has a edition' do
    expect(ill_transaction.loan_edition).to be 'Sixth edition.'
  end

  context 'without isbn' do
    let(:ill_transaction) { build(:ill_transaction_without_isbn) }

    it 'return nil' do
      expect(ill_transaction.isbn).to be_nil
    end
  end

  context 'with isbn' do
    it 'return an isbn' do
      expect(ill_transaction.isbn).to be '0873552555 (v. 1)'
    end
  end

  it 'has a username' do
    expect(ill_transaction.username).to eq 'xyz123'
  end
end
