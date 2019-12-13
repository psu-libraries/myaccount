# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsHelper do
  let(:checkout) do
    instance_double(
      Checkout,
      title: 'Test Title',
      catkey: 123,
      original_due_date: Time.zone.parse('2019-11-14T23:59:00-05:00'),
      overdue?: false,
      recalled?: false,
      claims_returned?: false
    )
  end

  describe '#render_checkout_title' do
    let(:content) { helper.render_checkout_title(checkout) }

    context 'when an item has an author' do
      before do
        allow(checkout).to receive_messages(author: 'Test Author')
      end

      it 'returns a linked title / author' do
        expect(content).to have_link 'Test Title / Test Author', href: 'https://catalog.libraries.psu.edu/catalog/123'
      end
    end

    context 'when an item does not have an author' do
      before do
        allow(checkout).to receive_messages(author: 'Test Author')
      end

      it 'returns a linked title' do
        expect(content).to have_link 'Test Title', href: 'https://catalog.libraries.psu.edu/catalog/123'
      end
    end
  end

  describe '#render_checkout_status' do
    let(:content) { helper.render_checkout_status(checkout) }

    context 'when an item is claims returned' do
      before do
        allow(checkout).to receive_messages(overdue?: true, claims_returned?: true)
      end

      it 'returns the right status' do
        expect(content).to eq 'Claims Returned'
      end
    end

    context 'when an item is overdue' do
      before do
        allow(checkout).to receive_messages(overdue?: true)
      end

      it 'returns the right status' do
        expect(content).to eq 'Overdue'
      end
    end

    context 'when an item is not overdue' do
      it 'returns an empty status' do
        expect(content).to be_nil
      end
    end
  end

  describe '#render_checkout_due_date' do
    let(:content) { helper.render_checkout_due_date(checkout) }

    context 'when an item is not recalled' do
      it 'renders the right html' do
        expect(content).to have_css('span', text: 'November 14, 2019 11:59pm')
      end
    end

    context 'when an item is recalled' do
      before do
        allow(checkout).to receive_messages(recalled?: true, recall_due_date: Time.zone.parse('2019-11-10T23:59:00-05:00'))
      end

      it 'renders the right html' do
        expect(content).to include('<span>Recalled<br>November 10, 2019 11:59pm<br>November 14, 2019 11:59pm</span>')
      end
    end
  end
end
