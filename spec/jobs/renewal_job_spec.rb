# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RenewalJob, type: :job do
  describe '#perform_later' do
    let(:mock_sc_client) { instance_double(SymphonyClient) }
    let(:ws_args) { { item_key: 1,
                      resource: '/catalog/item',
                      session_token: '1s2fa21465' } }
    let(:renewal_response) { RENEWAL_RAW_JSON.to_json }
    let(:sc_response) { instance_double(HTTP::Response, status: 200, body: renewal_response) }
    let(:redis_client) { instance_double(Redis) }

    before do
      allow(SymphonyClient).to receive(:new).and_return(mock_sc_client)
      allow(mock_sc_client).to receive(:renew).and_return(sc_response)
      allow(Redis).to receive(:new).and_return(redis_client)
      allow(redis_client).to receive(:set)
    end

    context 'with valid input' do
      it 'makes a call to the SymphonyClient' do
        described_class.perform_now(**ws_args)

        expect(mock_sc_client).to have_received(:renew)
      end
    end

    context 'with valid input that is returned OK from SymphonyClient' do
      it 'sets a Redis value that marks success' do
        described_class.perform_now(**ws_args)

        expect(redis_client).to have_received(:set).with('renewal_1', /success/)
      end

      it 'sets a Redis value that contains a translated item key' do
        described_class.perform_now(**ws_args)
        expect(redis_client).to have_received(:set).with('renewal_1', '{"item_key":1,'\
                                                                   '"result":"success","renewal_count":35,'\
                                                                   '"due_date":"May 15, 2020","status":null}')
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

        expect(redis_client).to have_received(:set).with('renewal_1', '{"item_key":1,"result":'\
                                                                    '"failure","error_message":"Some error message"}')
      end
    end
  end
end
