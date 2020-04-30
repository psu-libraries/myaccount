# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewHoldsJob, type: :job do
  let(:ws_args) { { patron_key: 'patron1',
                    session_token: '1s2fa21465' } }
  let(:redis_client) { Redis.new }

  after do
    Redis.new.del 'item_type_map'
  end

  context 'with valid input' do
    before do
      stub_request(:any, /example.com/).to_rack(FakeSymphony)
    end

    it 'sets a Redis record containing success denoted by patron\'s key' do
      described_class.perform_now(**ws_args)
      result = JSON.parse(redis_client.get('view_holds_patron1'))

      expect(result).to include('result' => 'success')
    end
  end

  context 'when SymphonyClient does not respond with 200/OK' do
    before do
      stub_request(:get, 'https://example.com/symwsbc/user/patron/key/patron1?includeFields=*,holdRecordList%7B*,bib%7Btitle,author,callList%7B*%7D%7D,item%7B*,bib%7Bshadowed,title,author%7D,call%7BsortCallNumber,dispCallNumber%7D%7D%7D')
        .to_return(status: 500, body: '{ "messageList": [{ "message": "A bad thing happened" }] }', headers: {})
    end

    it 'sets a Redis record containing failure denoted by patron\'s key' do
      described_class.perform_now(**ws_args)
      result = JSON.parse(redis_client.get('view_holds_patron1'))

      expect(result).to include('result' => 'failure')
    end
  end
end
