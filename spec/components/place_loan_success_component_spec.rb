# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceLoanSuccessComponent, type: :component do
  let(:bib) do
    {
      title: 'Some Title',
      author: 'Somebody',
      catkey: 'a_catkey',
      shadowed?: false
    }
  end
  let(:result) do
    {
      bib:,
      catkey: 'a_catkey',
      issn: 'an_ISSN',
      not_wanted_after: '2022-12-30',
      accept_alternate_edition: 'true',
      accept_ebook: 'true'
    }.with_indifferent_access
  end

  it 'renders when a loan request is placed successfully' do
    component = render_inline(described_class.new(result:)).to_html
    expect(component).to include('Some Title / Somebody', 'an_ISSN', 'December 30, 2022', 'Yes')
  end

  it 'does not render when a loan request is not placed' do
    result = {}
    component = render_inline(described_class.new(result:)).to_html
    expect(component).to be_empty
  end
end
