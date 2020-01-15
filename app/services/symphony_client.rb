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

  def renew_items(user, checkouts)
    checkouts.each_with_object(success: [], error: []) do |checkout, status|
      response = renew_item_request(checkout.resource,
                                    checkout.item_key,
                                    headers: { 'x-sirs-sessionToken': user.session_token })

      case response.status
      when 200
        status[:success] << checkout
      else
        status[:error] << [checkout, (error_message(response) || '')]
      end
    end
  end

  ITEM_RESOURCES = 'bib{title,author,callList{*}},item{*,bib{title,author},call{sortCallNumber,dispCallNumber}}'

  def cancel_hold(holdkey, session_token)
    authenticated_request('/circulation/holdRecord/cancelHold',
                          headers: { 'x-sirs-sessionToken': session_token },
                          method: :post, json: {
                            holdRecord: {
                              resource: '/circulation/holdRecord',
                              key: holdkey
                            }
                          })
  end

  private

    def renew_item_request(resource, item_key, headers: {})
      authenticated_request('/circulation/circRecord/renew', headers: headers, method: :post, json: {
                              item: {
                                resource: resource,
                                key: item_key
                              }
                            })
    end

    def error_message(response)
      return if response.status.ok?

      JSON.parse(response.body).dig('messageList')[0].dig('message')
    rescue JSON::ParserError
      nil
    end

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
