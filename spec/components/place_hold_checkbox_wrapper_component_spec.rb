# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldCheckboxWrapperComponent, type: :component do
  let(:hold1) { instance_double 'Hold', record: { 'fields' => { 'volumetric' => nil } },
                                        barcode: '12',
                                        call_number: 'A1',
                                        pickup_library_human: 'Library' }
  let(:hold2) { instance_double 'Hold', record: { 'fields' => { 'volumetric' => 'vol2' } },
                                        barcode: '12',
                                        call_number: 'A1',
                                        pickup_library_human: 'Library' }
  let(:hold3) { instance_double 'Hold', record: { 'fields' => { 'volumetric' => 'ch12' } },
                                        barcode: '12',
                                        call_number: 'A1',
                                        pickup_library_human: 'Library' }

  let(:items) { [hold1, hold2, hold3] }
  let(:component) { render_inline(described_class, items: items).to_html }

  it 'renders if any volumetric is present' do
    expect(component).not_to be_empty
  end

  it 'does not render if there are not any volumetrics' do
    component = render_inline(described_class, items: [hold1]).to_html

    expect(component).to be_empty
  end
end
