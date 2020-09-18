# frozen_string_literal: true

module MyaccountVersion
  def self.version
    version_from_github || 'not set'
  end

  def self.version_from_github
    client = Octokit::Client.new
    releases = client&.releases 'psu-libraries/myaccount'

    return unless good_response? releases

    # Strange notation below because this is not a Hash it is a Sawyer::Response
    releases&.first&.[] :name
  end

  # Weirdly, releases returns a String like "{}" OR an Array of Sawyer objects. :shrug:
  def self.good_response?(releases)
    releases.is_a?(Array) || JSON.parse(releases).present?
  end
end
