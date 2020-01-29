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
        expect(content).to have_css('span', text: 'November 14, 2019')
      end
    end

    context 'when an item is recalled' do
      before do
        allow(checkout).to receive_messages(
          recalled?: true,
          recall_due_date: Time.zone.parse('2019-11-10T22:30:00-05:00')
        )
      end

      it 'renders the right html' do
        expect(content).to have_css('span', text: 'RecalledNovember 10, 2019 10:30pmNovember 14, 2019')
      end
    end
  end

  describe '#format_due_date' do
    let(:content) { helper.format_due_date(due_date) }

    context 'when due date time is 11:59pm' do
      let(:due_date) { Time.zone.parse('2019-11-10T23:59:00-05:00') }

      it 'does not include the time' do
        expect(content).to eq('November 10, 2019')
      end
    end

    context 'when due date time is not 11:59pm' do
      let(:due_date) { Time.zone.parse('2019-11-10T22:30:00-05:00') }

      it 'includes the time' do
        expect(content).to include('November 10, 2019 10:30pm')
      end
    end
  end

  describe '#render_renewal_select' do
    before do
      allow(checkout).to receive_messages(item_key: '1111111:1:1')
    end

    it 'renders the right html' do
      checkbox = '<input type="checkbox" name="renewal_list[]" id="renewal_list_" '\
                 "value=\"#{checkout.item_key}\" data-checkbox-type=\"renewal\" class=\"checkbox\" "\
                 'multiple="multiple" />'
      expect(helper.render_renewal_select(checkout)).to include(checkbox)
    end
  end

  describe '#render_renew_button' do
    it 'renders the right html' do
      renew_button = '<input type="submit" name="commit" value="Renew" class="btn btn-primary btn-renewable-submit" '\
                     'data-disable-with="Renew" />'
      expect(helper.render_renew_button).to include(renew_button)
    end
  end

  describe '#render_renew_all' do
    it 'renders the right html' do
      renew_all = '<input type="checkbox" name="renew_all" id="renew_all" value="1" data-select-all="renewal" />'
      expect(helper.render_renew_all).to include(renew_all)
    end
  end
end
