# frozen_string_literal: true

Warden::Strategies.add(:library_id) do
  def valid?
    params['library_id'].present? && params['pin'].present?
  end

  def authenticate!
    response = SymphonyClient.new.login(params['library_id'], params['pin'])

    if response['patronKey']
      u = { username: params['library_id'], name: response['name'], patronKey: response['patronKey'] }
      success!(u)
    else
      fail!('Could not log in')
    end
  end
end