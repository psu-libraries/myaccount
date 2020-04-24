# frozen_string_literal: true

require 'sinatra/base'

class FakeSymphony < Sinatra::Base
  get '/symwsbc/user/patron/key/:key' do
    json_response 200, "patrons/#{params[:key]}.json"
  end

  get '/symwsbc/policy/itemType/simpleQuery' do
    json_response 200, 'other/item_type_map.json'
  end

  post '/symwsbc/circulation/holdRecord/changePickupLibrary' do
    content_type :json
    status 200
    {}.to_json
  end

  private

    def json_response(response_code, file_name)
      content_type :json
      status response_code
      File.open(File.dirname(__FILE__) + '/data/' + file_name, 'rb').read
    end
end