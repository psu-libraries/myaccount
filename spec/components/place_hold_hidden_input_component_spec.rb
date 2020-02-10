# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldHiddenInputComponent, type: :component do
  let(:bib_with_volumetrics) { build(:bib_with_volumetrics) }
  let(:bib_without_volumetrics) { build(:bib_without_volumetrics) }
  let(:component) { render_inline(described_class, bib: bib_without_volumetrics).to_html }

  it 'renders when volumetrics aren\'t detected' do
    expect(component).not_to be_empty
  end

  it 'does not render when volumetrics are detected' do
    component = render_inline(described_class, bib: bib_with_volumetrics).to_html
    expect(component).to be_empty
  end
end
