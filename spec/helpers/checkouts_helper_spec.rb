# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutsHelper do
  let(:checkout) do
    instance_double(
      Checkout,
      title: 'Test Title',
      catkey: 123,
      call_number: 'Test CallNumber',
      due_date: Time.zone.parse('2019-11-14T23:59:00-05:00'),
      overdue?: false,
      recalled?: false,
      claims_returned?: false
    )
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
        allow(checkout).to receive_messages(
          recalled?: true,
          recall_due_date: Time.zone.parse('2019-11-10T23:59:00-05:00')
        )
      end

      it 'renders the right html' do
        expect(content).to include('<span>Recalled<br>November 10, 2019 11:59pm<br>November 14, 2019 11:59pm</span>')
      end
    end
  end

  describe '#render_renewal_select' do
    let(:content) { helper.render_renewal_select(checkout) }

    before do
      allow(checkout).to receive_messages(item_key: '1111111:1:1')
    end

    it 'renders the right html' do
      checkbox = '<input type="checkbox" name="renewal_list[]" id="renewal_list_" '
      checkbox += "value=\"#{checkout.item_key}\" class=\"checkbox\" multiple=\"multiple\" />"
      expect(content).to include(checkbox)
    end
  end

  describe '#render_renew_button' do
    let(:content) { helper.render_renew_button }

    it 'renders the right html' do
      renew_button = '<input type="submit" name="commit" value="Renew" class="btn btn-primary btn-renewable-submit" '
      renew_button += 'data-disable-with="Renew" />'
      expect(content).to include(renew_button)
    end
  end
end
