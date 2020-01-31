# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  subject(:item) { build(:item) }

  it 'has a catkey' do
    item.record['fields']['bib']['key'] = '476022'
    expect(item.catkey).to eq '476022'
  end

  it 'has a author' do
    item.record['fields']['bib']['fields']['author'] = 'No Author'
    expect(item.author).to eq 'No Author'
  end

  it 'has a title' do
    item.record['fields']['bib']['fields']['title'] = 'National review'
    expect(item.title).to eq 'National review'
  end

  it 'has a format' do
    item.record['fields']['itemType']['key'] = 'PERIODICAL'
    expect(item.item_type_human).to eq 'Bound Journal'
  end

  it 'has a call number' do
    item.record['fields']['call']['fields']['dispCallNumber'] = 'AP2.N3545 v.17 no.28-52 1965'
    expect(item.call_number).to eq 'AP2.N3545 v.17 no.28-52 1965'
  end
end
