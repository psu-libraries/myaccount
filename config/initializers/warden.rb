# frozen_string_literal: true

Warden::Strategies.add(:library_id) do
  def valid?
    remote_user
  end

  def remote_user
    request.env.fetch("HTTP_REMOTE_USER", false) 
  end

  def authenticate!

    response = SymphonyClient.new.login(Settings.symws.username, Settings.symws.pin, remote_user)

    if response['patronKey']
      user = {
        username: remote_user,
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
