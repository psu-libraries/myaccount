# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldCheckboxWrapperComponent, type: :component do
  let(:bib_with_holdables) { build(:bib_with_holdables) }

  let(:holdables) { bib_with_holdables.holdables }
  let(:component) { render_inline(described_class, holdables: holdables).to_html }

  it 'renders if any holdables are present' do
    expect(component).not_to be_empty
  end

  it 'does not render if there are not any holdables present' do
    component = render_inline(described_class, holdables: []).to_html

    expect(component).to be_empty
  end
end
