# frozen_string_literal: true

# HTTP client wrapper for making requests to Symws
class SymphonyClient
  DEFAULT_HEADERS = {
    accept: 'application/json',
    content_type: 'application/json'
  }.freeze

  RENEWAL_CUSTOM_MESSAGELIST = {
    "hatErrorResponse.141": 'Renewal limit reached, cannot be renewed.',
    "hatErrorResponse.7703": 'Renewal limit reached, cannot be renewed.',
    "hatErrorResponse.105": 'Item has been recalled, cannot be renewed.',
    "hatErrorResponse.252": 'Item has holds, cannot be renewed.',
    "hatErrorResponse.46": 'Item on reserve, cannot be renewed.',
    "unhandledException": ''
  }.with_indifferent_access

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

  def change_pickup_library(hold_key:, pickup_library:, session_token:)
    authenticated_request('/circulation/holdRecord/changePickupLibrary',
                          headers: { 'x-sirs-sessionToken': session_token },
                          method: :post, json: {
                            holdRecord: {
                              resource: '/circulation/holdRecord',
                              key: hold_key
                            },
                            pickupLibrary: {
                              resource: '/policy/library',
                              key: pickup_library
                            }
                          })
  end

  def not_needed_after(hold_key:, fill_by_date:, session_token:)
    authenticated_request("/circulation/holdRecord/key/#{hold_key}",
                          headers: { 'x-sirs-sessionToken': session_token },
                          method: :put, json: {
                            resource: '/circulation/holdRecord',
                            key: hold_key,
                            fields: {
                              fillByDate: fill_by_date
                            }
                          })
  end

  def renew_items(user, checkouts)
    checkouts.each_with_object(success: [], error: []) do |checkout, status|
      response = renew_item_request(checkout.resource,
                                    checkout.item_key,
                                    headers: { 'x-sirs-sessionToken': user.session_token })

      case response.status
      when 200
        status[:success] << { renewal: checkout, sirsi_response: nil }
      else
        Rails.logger.error("Renewal (#{checkout.item_key}): #{response.body}")
        status[:error] << { renewal: checkout, sirsi_response: (renewal_error_message(response) || '') }
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

  def place_hold(patron, session_token, item_barcode, hold_args)
    body = {
      'itemBarcode': item_barcode,
      'patronBarcode': patron.barcode,
      'pickupLibrary': {
        'resource': '/policy/library',
        'key': hold_args[:pickup_library]
      },
      'holdType': 'TITLE',
      'holdRange': 'SYSTEM',
      'fillByDate': hold_args[:pickup_by_date]
    }.compact

    authenticated_request '/circulation/holdRecord/placeHold',
                          headers: {
                            'x-sirs-sessionToken': session_token,
                            'SD-Working-LibraryID': patron.library
                          },
                          method: :post,
                          json: body
  end

  def get_hold_info(hold_key, session_token)
    authenticated_request "/circulation/holdRecord/key/#{hold_key}",
                          headers: { 'x-sirs-sessionToken': session_token },
                          params: {
                            includeFields: '*,item{*,bib{title,author},call{*}}'
                          }
  end

  def get_item_info(barcode, session_token)
    get_item_info_path = "/catalog/item/barcode/#{barcode}"
    authenticated_request get_item_info_path, headers: { 'x-sirs-sessionToken': session_token },
                                              params: {
                                                includeFields: '*,bib{title,author},call{*}'
                                              }
  end

  def get_bib_info(catkey, session_token)
    get_bib_info_path = "/catalog/bib/key/#{catkey}"
    authenticated_request(get_bib_info_path, headers: { 'x-sirs-sessionToken': session_token },
                                             params: {
                                               includeFields: [
                                                 '*',
                                                 'callList{*,itemList{*}}'
                                               ].join(',')
                                             })
  end

  def retrieve_holdable_locations
    policy_path = '/policy/location/simpleQuery?key=*'
    request(policy_path, params: {
              includeFields: [
                'displayName',
                'holdable'
              ].join(',')
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
      JSON.parse(response.body).dig('messageList')[0].dig('message')
    end

    def renewal_error_message(response)
      return if response.status.ok?

      error_code = JSON.parse(response.body).dig('messageList')[0].dig('code')
      RENEWAL_CUSTOM_MESSAGELIST[error_code] || error_message(response)
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
