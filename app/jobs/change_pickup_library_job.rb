class ChangePickupLibraryJob < ApplicationJob
  queue_as :default

  def perform(pass_these)
    symphony_client = SymphonyClient.new
    redis_client = Redis.new
    response = symphony_client.change_pickup_library(hold_key: pass_these[:hold_key], pickup_library: pass_these[:pickup_library], session_token: pass_these[:session_token])


    case response.status
    when 200
      human_readable_location = Hold::PICKUP_LOCATION_ACTUAL[pass_these[:pickup_library].to_sym]
      redis_client.set(pass_these[:hold_key], {
          hold_id: pass_these[:hold_key],
          result: :success,
          new_value: human_readable_location,
          new_value_id: pass_these[:pickup_library]
      }.to_json)
    else
      Rails.logger.error(response.body)
      redis_client.set(pass_these[:hold_key], {hold_id: pass_these[:hold_key], result: :failure, response: response.body})
    end
  end
end
