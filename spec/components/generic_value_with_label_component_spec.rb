# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenericValueWithLabelComponent, type: :component do
  let(:value) { 'Eleventy Billion' }
  let(:label) { 'Number of Insects' }

  context 'when given an arbitrary simple field and value' do
    it 'produces a label to go along with the value' do
      expect(render_inline(described_class, label: label, value: value).to_html).to include '<strong>Number of '\
                                                                                            'Insects:</strong> '\
                                                                                            'Eleventy Billion'
    end
  end

  context 'when the given value is nil' do
    it 'does not print anything' do
      value = nil
      expect(render_inline(described_class, label: label, value: value).to_html).to be_empty
    end
  end
end
