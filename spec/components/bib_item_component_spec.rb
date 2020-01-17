# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BibItemComponent, type: :component do
  let(:hold) { build(:hold) }

  it 'renders a bib item with an author' do
    hold.record['fields']['bib']['fields']['title'] = 'A wonderful title'
    hold.record['fields']['bib']['fields']['author'] = 'A wonderful author'
    result = render_inline(described_class, bibitem: hold)
    expect(result.to_html).to include 'A wonderful title / A wonderful author</a>'
  end

  it 'renders a bib item without an author' do
    hold.record['fields']['bib']['fields']['title'] = 'A wonderful title'
    hold.record['fields']['bib']['fields']['author'] = ''
    result = render_inline(described_class, bibitem: hold)
    expect(result.to_html).to include 'A wonderful title</a>'
  end
end
