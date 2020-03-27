class ChangePickupLibraryJob < ApplicationJob
  queue_as :default

  def perform(pass_these)
    symphony_client = SymphonyClient.new
    response = symphony_client.change_pickup_library(hold_key: pass_these[:hold_key], pickup_library: pass_these[:pickup_library], session_token: pass_these[:session_token])

    case response.status
    when 200
      Redis.new.set(pass_these[:hold_key], {hold_id: pass_these[:hold_key], result: :success, new_value: pass_these[:pickup_library]}.to_json)
    else
      Rails.logger.error(response.body)
      Redis.new.set(pass_these[:hold_key], {hold_id: pass_these[:hold_key], result: :failure, response: response.body})
    end
  end
end
