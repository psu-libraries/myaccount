# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancelHoldJob, type: :job do
  describe '#perform_later' do
    let(:ws_args) { { hold_key: 1, session_token: '1s2fa21465' } }

    before do
      stub_request(:any, /example.com/).to_rack(FakeSymphony)
    end

    after do
      Redis.current.flushall
    end

    context 'with valid input' do
      it 'makes a call to the SymphonyClient' do
        described_class.perform_now(**ws_args)
        results = Redis.current.get 'cancel_hold_1'

        expect(results).to include('success')
      end
    end

    context 'with valid input that is returned OK from SymphonyClient' do
      it 'sets a Redis value that marks success' do
        described_class.perform_now(**ws_args)
        results = Redis.current.get 'cancel_hold_1'

        expect(results).to eq "{\"id\":1,\"result\":\"success\",\"response\":\"\\u003cp class='text-danger'\\u003eCancelled\\u003c/p\\u003e\"}"
      end
    end

    context 'with valid input that is returned not OK from SymphonyClient' do
      before do
        allow(sc_response).to receive(:status).and_return 500
        allow(mock_sc_client).to receive(:get_hold_info).and_return()
        allow(sc_response).to receive(:body).and_return({
          messageList: [{
            code: 'some_error_code',
            message: 'Some error message'
          }]
        }.to_json)
      end

      it 'makes a record of the failure' do
        described_class.perform_now(**ws_args)
        results = Redis.current.get 'cancel_hold_1'

        expect(results).to eq '{"hold_id":1,"result":"failure","response":"Some error message"}'
      end
    end
  end

end
