# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewHoldsJob do
  let(:ws_args) { { patron_key: 'patron1',
                    session_token: '1s2fa21465' } }

  after do
    Redis.current.flushall
  end

  context 'with valid input' do
    before do
      stub_request(:any, /example.com/).to_rack(FakeSymphony)
    end

    it 'sets a Redis record containing success denoted by patron\'s key' do
      described_class.perform_now(**ws_args)
      results = Redis.current.get 'view_holds_patron1'

      expect(results).to be_present
    end

    it 'renders HTML containing the holds and saves to redis' do
      described_class.perform_now(**ws_args)
      results = Redis.current.get 'view_holds_patron1'

      expect(results).to include 'Campfires of freedom : the camp life of Black soldiers during the Civil War'
    end
  end

  context 'when SymphonyClient does not respond with 200/OK' do
    before do
      stub_request(:get, 'https://example.com/symwsbc/user/patron/key/patron1?includeFields=*,customInformation{' \
                         'patronExtendedInformation{*}},address1,holdRecordList%7B*,' \
                         'bib%7Btitle,author,callList%7B*%7D%7D,' \
                         'item%7B*,bib%7Bshadowed,title,author%7D,call%7BsortCallNumber,dispCallNumber%7D%7D%7D')
        .to_return(status: 500, body: '{ "messageList": [{ "message": "A bad thing happened" }] }', headers: {})
    end

    it 'sets a Redis record containing failure denoted by patron\'s key' do
      described_class.perform_now(**ws_args)
      results = Redis.current.get 'view_holds_patron1'

      expect(results).to eq '{"result":"failure","response":{"messageList":[{"message":"A bad thing happened"}]}}'
    end
  end
end
