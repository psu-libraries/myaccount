# frozen_string_literal: true

Warden::Strategies.add(:library_id) do
  def valid?
    remote_user
  end

  def remote_user
    user = request.env.fetch(Settings.remote_user_header, false)
    user = user.split('@')[0] if user
    user
  end

  def authenticate!
    response = SymphonyClient.new.login(Settings.symws.username, Settings.symws.pin, remote_user) || {}

    if response.fetch('patronKey', nil)
      user = {
        username: remote_user,
        name: response['fields']['displayName'],
        patron_key: response['patronKey'],
        session_token: response['sessionToken']
      }

      success!(user)
    else
      fail!('Could not log in')
    end
  end
end
