# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceHoldCheckboxComponent, type: :component do
  let(:barcode) { 12 }
  let(:call_number) { 'A1' }
  let(:pickup_library_human) { 'Library' }

  context 'when a barcode is present' do
    let(:component) { render_inline(described_class,
                                    barcode: barcode,
                                    call_number: call_number,
                                    pickup_library: pickup_library_human).to_html
    }

    it 'renders when there is a barcode' do
      expect(component).not_to be_empty
    end

    it 'renders an input with a unique id attribute by barcode' do
      expect(component).to have_css('input#barcode_12')
    end

    it 'renders a label with a matching unique for attribute based on barcode' do
      expect(component).to have_css('label[for="barcode_12"]')
    end
  end

  context 'when the item does not have a barcode' do
    it 'does not render' do
      component = render_inline(described_class,
                                barcode: nil, call_number: call_number,
                                pickup_library: pickup_library_human).to_html
      expect(component).to be_empty
    end
  end
end
