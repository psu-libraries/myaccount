# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewIlliadLoansJob do
  let(:ill_args) { { webaccess_id: 'abc123',
                     type:,
                     library: 'UP-PAT' } }

  after do
    Redis.current.flushall
  end

  context 'when type: is :holds' do
    let(:type) { :holds }

    before do
      stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
        .with(
          headers: {
            'Apikey' => '1234',
            'Connection' => 'close',
            'Content-Type' => 'application/json',
            'Host' => 'illiad.illiad',
            'User-Agent' => 'http.rb/4.4.1'
          }
        )
        .to_return(status: 200, body: '[{"LoanTitle":"Unique Title"}]', headers: {})
    end

    it 'sets a Redis record containing success denoted by user\'s webaccess_id' do
      described_class.perform_now(**ill_args)
      results = Redis.current.get 'view_ill_holds_abc123'

      expect(results).to be_present
    end

    it 'renders HTML containing the holds and saves to redis' do
      described_class.perform_now(**ill_args)
      results = Redis.current.get 'view_ill_holds_abc123'

      expect(results).to include 'Interlibrary Loan Requests'
      expect(results).to include 'Unique Title'
    end

    context 'when IlliadClient does not respond with 200/OK' do
      before do
        stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
          .with(
            headers: {
              'Apikey' => '1234',
              'Connection' => 'close',
              'Content-Type' => 'application/json',
              'Host' => 'illiad.illiad',
              'User-Agent' => 'http.rb/4.4.1'
            }
          )
          .to_return(status: 400, body: '{"Message":"400 Error"}', headers: {})
      end

      it 'sets a Redis record containing failure denoted by user\'s webaccess_id' do
        described_class.perform_now(**ill_args)
        results = Redis.current.get 'view_ill_holds_abc123'

        expect(results).to eq '{"result":"failure","response":"400 Error"}'
      end
    end
  end

  context 'when type: is :checkouts' do
    let(:type) { :checkouts }

    before do
      stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
        .with(
          headers: {
            'Apikey' => '1234',
            'Connection' => 'close',
            'Content-Type' => 'application/json',
            'Host' => 'illiad.illiad',
            'User-Agent' => 'http.rb/4.4.1'
          }
        )
        .to_return(status: 200, body: '[{"LoanTitle":"Unique Title"}]', headers: {})
    end

    it 'sets a Redis record containing success denoted by user\'s webaccess_id' do
      described_class.perform_now(**ill_args)
      results = Redis.current.get 'view_ill_checkouts_abc123'

      expect(results).to be_present
    end

    it 'renders HTML containing the holds and saves to redis' do
      described_class.perform_now(**ill_args)
      results = Redis.current.get 'view_ill_checkouts_abc123'

      expect(results).to include 'Interlibrary Loan Checkouts'
      expect(results).to include 'Unique Title'
    end

    context 'when IlliadClient does not respond with 200/OK' do
      before do
        stub_request(:get, %r{https://illiad.illiad/illiad/ILLiadWebPlatform/Transaction/UserRequests})
          .with(
            headers: {
              'Apikey' => '1234',
              'Connection' => 'close',
              'Content-Type' => 'application/json',
              'Host' => 'illiad.illiad',
              'User-Agent' => 'http.rb/4.4.1'
            }
          )
          .to_return(status: 400, body: '{"Message":"400 Error"}', headers: {})
      end

      it 'sets a Redis record containing failure denoted by user\'s webaccess_id' do
        described_class.perform_now(**ill_args)
        results = Redis.current.get 'view_ill_checkouts_abc123'

        expect(results).to eq '{"result":"failure","response":"400 Error"}'
      end
    end
  end

  context 'when type: is :bogus' do
    let(:type) { :bogus }

    it 'raises StandardError' do
      expect { described_class.perform_now(**ill_args) }.to raise_error(StandardError)
    end
  end
end
