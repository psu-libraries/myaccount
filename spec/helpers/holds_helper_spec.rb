# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HoldsHelper, type: :helper do
  let(:hold) do
    instance_double(
      Hold,
      title: 'Test Title',
      catkey: 123
    )
  end

  describe '#render_queue_position' do
    context 'when there is a queue_position present' do
      before do
        allow(hold).to receive_messages(queue_position: 10)
      end

      it 'renders some pretext and then the position' do
        expect(helper.render_queue_position(hold)).to eq 'Your position in the holds queue: 10'
      end
    end

    context 'when there is not a queue_position present' do
      before do
        allow(hold).to receive_messages(queue_position: nil)
      end

      it 'renders unknown' do
        expect(helper.render_queue_position(hold)).to eq 'Unknown'
      end
    end
  end

  describe '#render_expiration_date' do
    context 'when there is an expiration date present' do
      before do
        expiration_date = DateTime.new(2025, 2, 3, 4, 5, 6)
        allow(hold).to receive_messages(expiration_date: expiration_date)
      end

      it 'renders some pretext and then the position' do
        expect(helper.render_expiration_date(hold)).to eq 'February 3, 2025'
      end
    end

    context 'when there is not a expiration date present' do
      before do
        allow(hold).to receive_messages(expiration_date: nil)
      end

      it 'renders never expires' do
        expect(helper.render_expiration_date(hold)).to eq 'Never expires'
      end
    end
  end

  describe '#render_status' do
    context 'when the hold is suspended' do
      before do
        suspend_begin_date = DateTime.new(2026, 4, 3, 4, 5, 6)
        allow(hold).to receive_messages(status_code: 'SUSPENDED')
        allow(hold).to receive_messages(suspend_begin_date: suspend_begin_date)
      end

      context 'when there is a suspended beginning and end date' do
        before do
          suspend_end_date = DateTime.new(2026, 4, 24, 4, 5, 6)
          allow(hold).to receive_messages(suspend_end_date: suspend_end_date)
        end

        it 'renders some pretext and a date range' do
          expect(helper.render_status(hold)).to eq '<em>Suspended from</em>: April 3, 2026 - April 24, 2026'
        end
      end

      context 'when there is only a suspended beginning date' do
        before do
          allow(hold).to receive_messages(suspend_end_date: nil)
        end

        it 'renders inactive' do
          expect(helper.render_status(hold)).to eq 'Inactive'
        end
      end
    end

    context 'when the hold is active' do
      before do
        allow(hold).to receive_messages(status_code: 'BEING_HELD')
      end

      it 'renders active' do
        expect(helper.render_status(hold)).to eq 'Active'
      end
    end
  end
end
