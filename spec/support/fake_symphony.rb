# frozen_string_literal: true

require 'sinatra/base'

class FakeSymphony < Sinatra::Base
  get '/symwsbc/user/patron/key/:key' do
    json_response 200, "patrons/#{params[:key]}.json"
  end

  get '/symwsbc/catalog/bib/key/:key' do
    json_response 200, "other/bib_#{params[:key]}.json"
  end

  get '/symwsbc/policy/location/simpleQuery' do
    json_response 200, 'other/locations.json'
  end

  get '/symwsbc/policy/itemType/simpleQuery' do
    json_response 200, 'other/item_type_map.json'
  end

  get '/symwsbc/circulation/holdRecord/key/:key' do
    json_response 200, 'other/hold.json'
  end

  get '/symwsbc/catalog/item/key/:key' do
    json_response 200, 'other/item.json'
  end

  post '/symwsbc/circulation/holdRecord/changePickupLibrary' do
    content_type :json
    status 200
    {}.to_json
  end

  put '/symwsbc/circulation/holdRecord/key/:key' do
    content_type :json
    status 200
    {}.to_json
  end

  post '/symwsbc/circulation/holdRecord/cancelHold' do
    content_type :json
    status 200
    {}.to_json
  end

  post '/symwsbc/circulation/circRecord/renew' do
    json_response 200, 'other/renewal.json'
  end

  private

    def json_response(response_code, file_name)
      content_type :json
      status response_code
      File.open(File.dirname(__FILE__) + '/data/' + file_name, 'rb').read
    end
end
