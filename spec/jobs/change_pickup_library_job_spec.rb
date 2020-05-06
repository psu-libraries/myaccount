# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangePickupLibraryJob, type: :job do
  describe '#perform_later' do
    let(:mock_sc_client) { instance_double(SymphonyClient) }
    let(:ws_args) { { hold_key: 1,
                      pickup_library: 'HERSHEY',
                      session_token: '1s2fa21465' } }
    let(:sc_response) { instance_double(HTTP::Response, status: 200) }

    before do
      allow(SymphonyClient).to receive(:new).and_return(mock_sc_client)
      allow(mock_sc_client).to receive(:change_pickup_library).and_return(sc_response)
    end

    after do
      $REDIS_CLIENT.flushall
    end

    context 'with valid input' do
      it 'makes a call to the SymphonyClient' do
        described_class.perform_now(**ws_args)

        expect(mock_sc_client).to have_received(:change_pickup_library)
      end
    end

    context 'with valid input that is returned OK from SymphonyClient' do
      it 'sets a Redis value that marks success' do
        described_class.perform_now(**ws_args)
        results = $REDIS_CLIENT.get 'pickup_library_1'

        expect(results).to be_present
      end

      it 'sets a Redis value that contains a translated pickup library code' do
        described_class.perform_now(**ws_args)
        results = $REDIS_CLIENT.get 'pickup_library_1'

        expect(results).to include 'Hershey (College of Medicine)'
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
        results = $REDIS_CLIENT.get 'pickup_library_1'

        expect(results).to eq '{"hold_id":1,"result":"failure","response":"Some error message"}'
      end
    end
  end
end
