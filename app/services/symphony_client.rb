# frozen_string_literal: true

# HTTP client wrapper for making requests to Symws
class SymphonyClient
  DEFAULT_HEADERS = {
    accept: 'application/json',
    content_type: 'application/json'
  }.freeze

  ITEM_RESOURCES = [
    'bib{title,author,callList{*}}',
    'item{*,bib{shadowed,title,author},call{sortCallNumber,dispCallNumber}}'
  ].join(',')

  DELAY = 0.05

  def login(user_id, password)
    response = request('/user/patron/login', method: :post, json: {
                         login: user_id,
                         password: password
                       })
    JSON.parse(response.body)
  end

  # This method is for validating user session_token
  def ping?(user)
    response = authenticated_request("/user/patron/key/#{user.patron_key}",
                                     headers: { 'x-sirs-sessionToken': user.session_token },
                                     params: { includeFields: 'key' })

    response.status == 200
  end

  def patron_info(patron_key:, session_token:, item_details: {})
    response = authenticated_request("/user/patron/key/#{patron_key}",
                                     headers: { 'x-sirs-sessionToken': session_token },
                                     params: {
                                       includeFields: [
                                         '*',
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

  def renew(resource:, item_key:, session_token:)
    authenticated_request('/circulation/circRecord/renew',
                          headers: { 'x-sirs-sessionToken': session_token },
                          method: :post, json: {
                            item: {
                              resource: resource,
                              key: item_key
                            }
                          }, params: {
                            includeFields: 'circRecord{*}'
                          })
  end

  def cancel_hold(hold_key:, session_token:)
    authenticated_request('/circulation/holdRecord/cancelHold',
                          headers: { 'x-sirs-sessionToken': session_token },
                          method: :post, json: {
                            holdRecord: {
                              resource: '/circulation/holdRecord',
                              key: hold_key
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
                            includeFields: '*,item{*,bib{shadowed,title,author},call{*}}'
                          }
  end

  def get_item_info(barcode = nil, session_token = nil, key = nil)
    request_path_suffix = if barcode.present?
                            "barcode/#{barcode}"
                          elsif key.present?
                            "key/#{key}"
                          end

    authenticated_request "/catalog/item/#{request_path_suffix}",
                          headers: { 'x-sirs-sessionToken': session_token },
                          params: {
                            includeFields: '*,bib{shadowed,title,author},call{*}'
                          }
  end

  def get_item_type_map
    response = request('/policy/itemType/simpleQuery', params: {
                         key: '*', includeFields: 'displayName,description'
                       })

    JSON.parse(response.body)
  end

  def get_bib_info(catkey, session_token)
    authenticated_request "/catalog/bib/key/#{catkey}",
                          headers: { 'x-sirs-sessionToken': session_token },
                          params: {
                            includeFields: '*,callList{*,itemList{*}}'
                          }
  end

  def get_all_locations
    policy_path = '/policy/location/simpleQuery?key=*'
    request(policy_path, params: {
              includeFields: [
                'displayName',
                'holdable'
              ].join(',')
            })
  end

  private

    def error_code(response)
      return if response.status.ok?

      JSON.parse(response.body).dig('messageList').first.dig('code')
    rescue JSON::ParserError
      nil
    end

    def records_in_use?(response)
      error_code(response) == 'hatErrorResponse.116'
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
      start = DateTime.now
      response = request(path, headers: headers, **other)

      while records_in_use?(response) && start + 5.seconds > DateTime.now
        sleep DELAY
        response = request(path, headers: headers, **other)
      end

      response
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
