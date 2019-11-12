# frozen_string_literal: true

# HTTP client wrapper for making requests to Symws
class SymphonyClient
  DEFAULT_HEADERS = {
    accept: 'application/json',
    content_type: 'application/json'
  }.freeze

  # ping the symphony endpoint to make sure we can establish a connection
  def ping
    session_token.present?
  rescue HTTP::Error
    false
  end

  def login(user_id, password)
    response = authenticated_request('/user/patron/login', method: :post, json: {
                                       login: user_id,
                                       password: password
                                     })

    JSON.parse(response.body)
  end

  # get a session token by authenticating to symws
  def session_token
    @session_token ||= begin
      response = request('/user/patron/login', method: :post, json: Settings.symws.login_params)

      JSON.parse(response.body)['sessionToken']
    end
  end

  def patron_info(patron_key, item_details: {})
    response = authenticated_request("/user/patron/key/#{patron_key}", params: {
                                       includeFields: [
                                         '*',
                                         'address1',
                                         *patron_linked_resources_fields(item_details)
                                       ].join(',')
                                     })
    JSON.parse(response.body)
  end

  ITEM_RESOURCES = 'bib{title,author,callList{*}},item{*,bib{title,author},call{sortCallNumber,dispCallNumber}}'

  def patron_linked_resources_fields(item_details = {})
    [
      "holdRecordList{*,#{ITEM_RESOURCES if item_details[:holdRecordList]}}",
      'circRecordList{*,circulationRule{loanPeriod{periodType{key}},renewFromPeriod},' \
      "#{ITEM_RESOURCES if item_details[:circRecordList]}}",
      "blockList{*,#{ITEM_RESOURCES if item_details[:blockList]}}"
    ]
  end

  private

    def authenticated_request(path, headers: {}, **other)
      request(path, headers: headers.merge('x-sirs-sessionToken': session_token), **other)
    end

    def request(path, headers: {}, method: :get, **other)
      HTTP
        .use(instrumentation: { instrumenter: ActiveSupport::Notifications.instrumenter, namespace: 'symphony' })
        .headers(default_headers.merge(headers))
        .request(method, base_url + path, **other)
    end

    def base_url
      Settings.symws.url
    end

    def default_headers
      DEFAULT_HEADERS.merge(Settings.symws.headers || {})
    end
end
