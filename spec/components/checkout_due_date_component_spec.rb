# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutDueDateComponent, type: :component do
  let(:checkout) { build(:checkout) }
  let(:component) { render_inline(described_class, checkout: checkout).to_html }

  before do
    checkout.record['fields']['dueDate'] = '2019-11-20T23:59:00-05:00'
    checkout.record['fields']['recalledDate'] = ''
    checkout.record['fields']['recallDueDate'] = ''
  end

  context 'when an item is not recalled' do
    it 'renders the right due dates' do
      expect(component).to eq 'November 20, 2019'
    end
  end

  context 'when an item is recalled' do
    it 'renders the right due dates' do
      checkout.record['fields']['recalledDate'] = '2019-11-09'
      checkout.record['fields']['recallDueDate'] = '2019-11-09T22:30:00-05:00'
      expect(component).to eq('Recalled&lt;br&gt;November  9, 2019 10:30pm&lt;br&gt;November 20, 2019')
    end
  end

  context 'when record passed doesn\'t contain a due date' do
    it 'doesn\'t render anything' do
      checkout.record['fields']['dueDate'] = ''
      checkout.record['fields']['recalledDate'] = ''
      checkout.record['fields']['recallDueDate'] = ''

      expect(component).to be_empty
    end
  end
end
