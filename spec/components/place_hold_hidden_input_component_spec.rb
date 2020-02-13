# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldHiddenInputComponent, type: :component do
  let(:bib_with_holdables) { build(:bib_with_holdables) }
  let(:bib_without_holdables) { build(:bib_without_holdables) }
  let(:component) { render_inline(described_class, bib: bib_without_holdables).to_html }

  it 'renders when there are one or no holdable items to request' do
    expect(component).not_to be_empty
  end

  it 'does not render when there are more than one holdable items to request' do
    component = render_inline(described_class, bib: bib_with_holdables).to_html
    expect(component).to be_empty
  end
end
