# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SirsiResponse::Error, type: :service do
  describe '#initialize' do
    subject { described_class.new error_message_raw: error_response_obj,
                                  symphony_client: mock_client,
                                  key: key,
                                  session_token: session_token,
                                  bib_type: bib_type }

    let(:error) { subject }
    let(:error_code) { 'Not a real code 1234' }
    let(:error_message) { 'Some error message' }
    let(:error_response_obj) {
      { 'messageList' => [{ 'code' => error_code,
                            'message' => error_message }] }
    }
    let(:mock_client) { SymphonyClient.new } # Creates actual object, stubs API responses with Sinatra
    let(:key) { '123457' }
    let(:session_token) { '92929292' }
    let(:bib_type) { 'checkout' }

    after do
      Redis.current.flushall
    end

    context 'when an error occurs that does not have a translation' do
      it 'returns a generic error response in HTML' do
        expect(error.html).to include '<p>Some error message Contact your campus library if you need assistance.</p>'
      end

      it 'logs the server response from Sirsi' do
        expect(error.log).to include 'messageList' => [{ 'code' => 'Not a real code 1234',
                                                         'message' => 'Some error message' }]
      end
    end

    context 'when an error for a hold occurs that is malformed' do
      let(:error_message) { nil }

      it 'returns a generic error response in HTML' do
        expect(error.html).to include '<p>Something went wrong Contact your campus library if you need assistance.</p>'
      end

      it 'logs the server response from Sirsi' do
        expect(error.log).to include 'messageList' => [{ 'code' => 'Not a real code 1234', 'message' => nil }]
      end
    end

    context 'when an error for a checkout occurs that has a translation' do
      let(:bib_type) { 'checkout' }
      let(:error_code) { 'hatErrorResponse.46' }

      it 'returns a generic error response in HTML' do
        expect(error.html).to include '<p>Denied: Item on reserve, cannot be renewed.'
      end

      it 'logs the server response from Sirsi' do
        expect(error.log).to include 'messageList' => [{ 'code' => 'hatErrorResponse.46',
                                                         'message' => 'Some error message' }]
      end
    end
  end
end
