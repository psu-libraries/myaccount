# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BibItemComponent, type: :component do
  let(:hold) { build(:hold) }

  it 'renders a bib item with an author' do
    hold.record['fields']['bib']['fields']['title'] = 'A wonderful title'
    hold.record['fields']['bib']['fields']['author'] = 'A wonderful author'

    result = render_inline(described_class, bibitem: hold)
    expect(result.to_html).to include 'A wonderful title / A wonderful author'
  end

  it 'renders a bib item without an author' do
    hold.record['fields']['bib']['fields']['title'] = 'A wonderful title'
    hold.record['fields']['bib']['fields']['author'] = ''
    result = render_inline(described_class, bibitem: hold)
    expect(result.to_html).to include 'A wonderful title'
  end

  context 'when bib item type is anything but PALCI' do
    before do
      hold.record['fields']['item']['fields']['itemType']['key'] = 'ATLAS'
    end

    it 'renders an linked title' do
      result = render_inline(described_class, bibitem: hold)
      expect(result.to_html).to include 'href'
    end
  end

  context 'when bib item is from PALCI' do
    before do
      hold.record['fields']['item']['fields']['itemType']['key'] = 'PALCI'
    end

    it 'renders an unlinked title' do
      result = render_inline(described_class, bibitem: hold)
      expect(result.to_html).not_to include 'href'
    end
  end
end
