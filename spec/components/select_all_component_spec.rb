# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SelectAllComponent, type: :component do
  let(:select_all_args) { { target_keyword: 'renewal' } }

  let(:component) { render_inline(described_class.new(select_all_args)).to_html }

  it 'makes a select all checkbox' do
    expect(component).to include 'input type="checkbox" name="renewal_all"'
  end

  it 'adds the correct data attribute to bind the target checkboxes' do
    expect(component).to include 'data-select-all="renewal"'
  end

  it 'render a label for select all' do
    expect(component).to include '<label class="sr-only" for="renewal_all">All</label>'
  end
end
