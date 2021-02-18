# frozen_string_literal: true

Warden::Strategies.add(:library_id) do
  def valid?
    params['user_id'].present? && params['password'].present?
  end

  def authenticate!
    response = SymphonyClient.new.login(params['user_id'], params['password'])

    if response['patronKey']
      user = {
        username: params['user_id'],
        name: response['name'],
        patron_key: response['patronKey'],
        session_token: response['sessionToken']
      }

      success!(user)
    else
      fail!('Could not log in')
    end
  end
end
