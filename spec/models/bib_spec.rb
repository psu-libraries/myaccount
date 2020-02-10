# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bib, type: :model do
  subject(:bib) { build(:bib_with_volumetrics) }

  it 'will generate new holds when supplied with a body that has a callList' do
    results = Bib::generate_holds(bib.body)

    expect(results.count).to be 8
  end

  it 'will show you an author' do
    expect(bib.author).to be 'Hill Street blues (Television program)'
  end

end
