# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bib, type: :model do
  subject(:bib) { build(:bib_with_holdables) }

  it 'will generate holdables when supplied with a body that has a callList' do
    expect(bib.holdables.count).to be 8
  end

  it 'will show you an author' do
    expect(bib.author).to be 'Hill Street blues (Television program)'
  end

  context 'with an item list of only one item' do
    it 'will not generate any new holds' do
    end
  end

  context 'with an item list without any holdable items' do
    it 'will not generate any new holds' do
    end
  end

  context 'with an item list with only one holdable item' do
    it 'will not generate any new holds' do
    end
  end

  context 'with an item list where more than 1 item os holdable and some items are not holdable are empty' do
    it 'will not generate any new holds for empty items' do
    end
  end
end
