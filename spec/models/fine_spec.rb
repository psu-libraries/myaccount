# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fine do
  subject(:fine) do
    described_class.new({
      key: '1',
      fields: fields
    }.with_indifferent_access)
  end

  let(:fields) do
    { 'amount' => { 'currencyCode' => 'USD', 'amount' => '12.00' }, 'tax' => { 'currencyCode' => 'USD', 'amount' => '0.00' }, 'billDate' => '2019-10-08', 'estimatedOverdueAmount' => { 'currencyCode' => 'USD', 'amount' => '0.00' }, 'title' => 'This changes everything : capitalism vs. the climate', 'owed' => { 'currencyCode' => 'USD', 'amount' => '12.00' }, 'library' => { 'resource' => '/policy/library', 'key' => 'UP-PAT' }, 'callNumber' => 'HC79.E5K56 2014', 'block' => { 'resource' => '/policy/block', 'key' => 'RECALLOVD' }, 'comment' => nil, 'itemLibrary' => { 'resource' => '/policy/library', 'key' => 'UP-PAT' }, 'createDate' => '2019-10-08' }
  end

  it 'has a fee' do
    expect(fine.fee).to eql? 12
  end
end
