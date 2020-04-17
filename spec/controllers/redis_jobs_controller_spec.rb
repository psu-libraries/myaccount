# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisJobsController, type: :controller do
  let(:mock_redis_client) { instance_double(Redis) }
  let(:redis_response) { '{"hold_id":"3911148","result":"success",'\
                         '"new_value":"Brandywine","new_value_id":"BRANDYWINE"}' }

  before do
    allow(Redis).to receive(:new).and_return(mock_redis_client)
  end

  describe '#show' do
    before do
      allow(mock_redis_client).to receive(:get).and_return(redis_response)
    end

    it 'retrieves and renders json form of the job' do
      get :show, params: { id: 3911148, format: 'json' }

      expect(response.body).to include redis_response
    end
  end

  describe '#destroy' do
    before do
      allow(mock_redis_client).to receive(:del).and_return 1
    end

    it 'sends a delete message to the redis client and returns the results' do
      delete :destroy, params: { id: 3911148 }

      expect(response.body).to eq '1'
    end
  end
end
