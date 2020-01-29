# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SelectAllChildComponent, type: :component do
  let(:select_all_child_args) { { type: 'renewal', key: '1111111:1:1' } }

  let(:component) { render_inline(described_class, select_all_child_args).to_html }

  context 'when a name is not given as an argument, uses type as name' do
    it 'makes a child checkbox' do
      expect(component).to include 'input type="checkbox" name="renewal_list[]"'
    end
  end

  context 'when a name is given' do
    let(:select_all_child_args) { { type: 'renewal', key: '1111111:1:1', name: 'other_name' } }

    it 'makes a child checkbox with that name' do
      expect(component).to include 'input type="checkbox" name="other_name_list[]"'
    end
  end

  it 'adds the correct data attribute to bind the checkbox to select all' do
    expect(component).to include 'data-checkbox-type="renewal"'
  end
end
