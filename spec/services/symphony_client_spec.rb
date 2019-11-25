# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SymphonyClient do
  let(:client) { subject }

  describe '#login' do
    before do
      stub_request(:post, Settings.symws.url + '/user/patron/login')
        .with(body: Settings.symws.login_params.to_h,
              headers: Settings.symws.headers)
        .to_return(body: { patronKey: Settings.symws.patron_key }.to_json) # , sessionToken: 'tokentokentoken'
    end

    it 'authenticates the user against symphony' do
      expect(client.login(Settings.symws.login_params.login,
                          Settings.symws.login_params.password)).to include 'patronKey' => Settings.symws.patron_key + '1'
    end
  end

  # describe '#patron_info' do
  #   before do
  #     stub_request(:get, Settings.symws.patron_info)
  #         .with(query: hash_including(includeFields: match(/\*/)))
  #         .to_return(body: { key: 'somepatronkey' }.to_json)
  #   end
  #
  #   it 'authenticates the user against symphony' do
  #     expect(client.patron_info('somepatronkey')).to include 'key' => 'somepatronkey'
  #   end
  #
  #   context 'when requesting item details' do
  #     it 'requests the item details for checkouts' do
  #       client.patron_info('somepatronkey', item_details: { circRecordList: true })
  #
  #       expect(WebMock).to have_requested(:get, 'https://example.com/symws/user/patron/key/somepatronkey')
  #                              .with(query: hash_including(includeFields: match(/circRecordList{.*,item{.*}}/)))
  #     end
  #
  #     it 'requests the item details for requests' do
  #       client.patron_info('somepatronkey', item_details: { holdRecordList: true })
  #
  #       expect(WebMock).to have_requested(:get, 'https://example.com/symws/user/patron/key/somepatronkey')
  #                              .with(query: hash_including(includeFields: match(/holdRecordList{.*,item{.*}}/)))
  #     end
  #
  #     it 'requests the item details for fines' do
  #       client.patron_info('somepatronkey', item_details: { blockList: true })
  #
  #       expect(WebMock).to have_requested(:get, 'https://example.com/symws/user/patron/key/somepatronkey')
  #                              .with(query: hash_including(includeFields: match(/blockList{.*,item{.*}}/)))
  #     end
  #   end
  # end
end
