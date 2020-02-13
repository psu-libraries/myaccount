# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldCheckboxComponent, type: :component do
  let(:barcode) { 12 }
  let(:call_number) { 'A1' }
  let(:pickup_library_human) { 'Library' }

  it 'renders when there is a barcode' do
    component = render_inline(described_class,
                              barcode: barcode,
                              call_number: call_number,
                              pickup_library: pickup_library_human).to_html
    expect(component).to include 'input'
  end

  it 'does not render when there is not a barcode' do
    barcode = nil
    component = render_inline(described_class,
                              barcode: barcode, call_number: call_number,
                              pickup_library: pickup_library_human).to_html
    expect(component).to be_empty
  end
end
