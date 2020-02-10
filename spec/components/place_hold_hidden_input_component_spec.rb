# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldHiddenInputComponent, type: :component do
  let(:bib) { build(:bib_with_volumetrics) }
  let(:component) { render_inline(described_class, bib: bib).to_html }

  it 'renders when volumetrics aren\'t detected' do
    expect(component).to_not be_empty
  end

  it 'does not render when volumetrics are detected' do
    expect(component).to be_empty
  end
end
