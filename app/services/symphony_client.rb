# frozen_string_literal: true

# HTTP client wrapper for making requests to Symws
class SymphonyClient
  DEFAULT_HEADERS = {
    accept: 'application/json',
    content_type: 'application/json'
  }.freeze

  def login(user_id, password)
    response = request('/user/patron/login', method: :post, json: {
                         login: user_id,
                         password: password
                       })
    JSON.parse(response.body)
  end

  def patron_info(user, item_details: {})
    response = authenticated_request("/user/patron/key/#{user.patron_key}",
                                     headers: { 'x-sirs-sessionToken': user.session_token },
                                     params: {
                                       includeFields: [
                                         '*',
                                         'address1',
                                         *patron_linked_resources_fields(item_details)
                                       ].join(',')
                                     })
    JSON.parse(response.body)
  end

  ITEM_RESOURCES = 'bib{title,author,callList{*}},item{*,bib{title,author},call{sortCallNumber,dispCallNumber}}'

  private

    def patron_linked_resources_fields(item_details = {})
      case item_details
      when ->(h) { h[:blockList] }
        ["blockList{*,#{ITEM_RESOURCES}}"]
      when ->(h) { h[:circRecordList] }
        ["circRecordList{*,#{ITEM_RESOURCES}}"]
      when ->(h) { h[:holdRecordList] }
        ["holdRecordList{*,#{ITEM_RESOURCES}}"]
      else
        [
          'blockList{*}',
          'holdRecordList{*}',
          'circRecordList{*}'
        ]
      end
    end

    def authenticated_request(path, headers: {}, **other)
      # binding.pry
      request(path, headers: headers, **other)
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
