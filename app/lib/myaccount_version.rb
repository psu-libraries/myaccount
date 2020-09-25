# frozen_string_literal: true

module MyaccountVersion
  def self.version
    retrieve_version
  end

  VERSION_CACHE_TIME = 300
  VERSION_NOT_SET_NAME = 'Version could not be determined'

  def self.retrieve_version
    set_version
    Redis.current.get 'myaccount_version'
  end

  # `nx: true` means that Redis will only set this value if it doesn't exist. The `ex` option tells Redis when to delete
  # the key.
  def self.set_version
    Redis.current.set 'myaccount_version', version_from_github, ex: VERSION_CACHE_TIME, nx: true
  end

  def self.version_from_github
    client = Octokit::Client.new
    releases = client&.releases 'psu-libraries/myaccount'

    return VERSION_NOT_SET_NAME unless good_response? releases

    # Strange notation below because this is not a Hash it is a Sawyer::Response
    releases&.first&.[] :name || VERSION_NOT_SET_NAME
  end

  # Weirdly, releases returns a String like "{}" OR an Array of Sawyer objects. :shrug:
  def self.good_response?(releases)
    releases.is_a?(Array) || JSON.parse(releases).present?
  end
end
