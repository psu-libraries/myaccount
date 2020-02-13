# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bib, type: :model do
  let(:bib_with_holdables) { build(:bib_with_holdables) }
  let(:bib_without_holdables) { build(:bib_without_holdables) }

  it 'will generate holdables when supplied with a body that has a callList' do
    expect(bib_with_holdables.holdables.count).to be 8
  end

  it 'will show you an author' do
    expect(bib_with_holdables.author).to be 'Hill Street blues (Television program)'
  end

  context 'with an item list that does not contain any volumetrics' do
    it 'will not generate any new holds' do
      allow(bib_without_holdables).to receive(:volumetric?).and_return(false)

      expect(bib_without_holdables.holdables).to be nil
    end
  end

  context 'with an item list without any holdable items' do
    it 'will not generate any new holds' do
      expect(bib_without_holdables.holdables).to be nil
    end
  end

  context 'with an item list with only one potential holdable item' do
    it 'will not generate any new holds' do
      allow(bib_without_holdables).to receive(:potential_holdables).and_return([instance_double('Hold')])

      expect(bib_without_holdables.holdables).to be nil
    end
  end

  context 'with an item list where there is only one holdable item' do
    it 'will not generate any new holds' do
      allow(bib_without_holdables).to receive(:filter_holdables).and_return([instance_double('Hold')])

      expect(bib_without_holdables.holdables).to be nil
    end
  end
end
