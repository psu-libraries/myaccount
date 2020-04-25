# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangePickupByDateJob, type: :job do
  describe '#perform_later' do
    let(:mock_sc_client) { instance_double(SymphonyClient) }
    let(:ws_args) { { hold_key: 1,
                      pickup_by_date: '2010-01-01',
                      session_token: '1s2fa21465' } }
    let(:sc_response) { instance_double(HTTP::Response, status: 200) }
    let(:redis_client) { instance_double(Redis) }

    before do
      allow(SymphonyClient).to receive(:new).and_return(mock_sc_client)
      allow(mock_sc_client).to receive(:not_needed_after).and_return(sc_response)
      allow(Redis).to receive(:new).and_return(redis_client)
      allow(redis_client).to receive(:set)
    end

    context 'with valid input' do
      it 'makes a call to the SymphonyClient' do
        described_class.perform_now(**ws_args)

        expect(mock_sc_client).to have_received(:not_needed_after)
      end
    end

    context 'with valid input that is returned OK from SymphonyClient' do
      it 'sets a Redis value that marks success' do
        described_class.perform_now(**ws_args)

        expect(redis_client).to have_received(:set).with('pickup_by_date_1', /success/)
      end

      it 'sets a Redis value that contains a translated pickup library code' do
        described_class.perform_now(**ws_args)

        expect(redis_client).to have_received(:set).with('pickup_by_date_1', /2010-01-01/)
      end
    end

    context 'with valid input that is returned not OK from SymphonyClient' do
      before do
        allow(sc_response).to receive(:status).and_return 500
        allow(sc_response).to receive(:body).and_return({
          messageList: [{
            code: 'some_error_code',
            message: 'Some error message'
          }]
        }.to_json)
      end

      it 'makes a record of the failure' do
        described_class.perform_now(**ws_args)

        expect(redis_client).to have_received(:set).with('pickup_by_date_1', '{"hold_id":1,"result":'\
                                                                    '"failure","response":"Some error message"}')
      end
    end
  end
end