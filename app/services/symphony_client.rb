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

  DELAY = 0.75
  MAX_WAIT_TIME = 30
  SAFE_PATRON_ADDRESS_FIELDS = [:email, :street1, :street2, :zip].freeze

  def get_patron_record(remote_user, session_token)
    user = Hash.new
    resp = authenticated_request("/user/patron/search",
                                 headers: { 'x-sirs-sessionToken': session_token},
                                 params: {
                                   q: "ALT_ID:#{remote_user.upcase}",
                                   includeFields: '*'
                                 })
    return nil unless resp.status == 200
    resp = JSON.parse(resp.body)['result'].first
    return nil unless resp
    user['patronKey'] = resp['key']
    user['fields'] = resp['fields']
    user['sessionToken'] = session_token
    user
  end

  def login(user_id, password, remote_user=nil)
    response = request('/user/staff/login', method: :post, json: {
                         login: user_id,
                         password: password
                       })
    resp = JSON.parse(response.body)
    session_token = resp['sessionToken']
    get_patron_record(remote_user, session_token)
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

  def update_patron_info(patron:, params:, session_token:)
    body = {
      "resource": '/user/patron',
      "key": patron.key,
      "fields": {
        "lastName": params[:last_name],
        "middleName": params[:middle_name],
        "firstName": params[:first_name],
        "suffix": params[:suffix],
        "address1": patron_address(params)
      }
    }

    authenticated_request "/user/patron/key/#{patron.key}",
                          headers: {
                            'x-sirs-sessionToken': session_token
                          },
                          method: :put,
                          json: body
  end

  def get_hold_info(hold_key, session_token)
    response_raw = hold_request hold_key, session_token

    start = DateTime.now

    while hold_missing_title?(response_raw) && time_left_to_request_again?(start)
      sleep DELAY
      response_raw = hold_request hold_key, session_token
    end

    response_raw
  end

  def get_item_info(session_token:, barcode: nil, key: nil)
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

    def patron_address(params)
      params.permit(SAFE_PATRON_ADDRESS_FIELDS)
        .to_h
        .transform_keys(&:camelize)
        .transform_keys(&:upcase)
        .map { |field, value| patron_address_1_template field: field, value: value }
        .push patron_address_1_template field: 'CITY/STATE', value: "#{params[:city]}, #{params[:state]}"
    end

    def patron_address_1_template(field:, value:)
      {
        "resource": '/user/patron/address1',
        "fields":
              {
                "code": {
                  "resource": '/policy/patronAddress1',
                  "key": field
                },
                "data": value
              }
      }
    end

    def time_left_to_request_again?(start)
      return true if DateTime.now < (start + MAX_WAIT_TIME.seconds)

      # Log a terrible event: a request that has hung for too long leaving the user stranded. User will get a "Network
      # Error" message if this occurs.
      Sidekiq.logger.error 'Request timeout reached'
      false
    end

    def hold_request(hold_key, session_token)
      authenticated_request "/circulation/holdRecord/key/#{hold_key}",
                            headers: { 'x-sirs-sessionToken': session_token },
                            params: {
                              includeFields: '*,item{*,bib{shadowed,title,author},call{*}}'
                            }
    end

    # This is here to check for a malformed response from Sirsi's web service where, probably due to the "record being
    # busy", the hold is missing item info of title.
    def hold_missing_title?(response_raw)
      response = JSON.parse response_raw.body

      if Hold.new(response).title.nil?
        Sidekiq.logger.error 'Hold\'s title missing... trying again'
        return true
      end
      false
    end

    def error_code(response)
      return if response.status.ok?

      JSON.parse(response.body)['messageList'].first['code']
    rescue JSON::ParserError
      nil
    end

    def records_in_use?(response)
      return false unless error_code(response) == 'hatErrorResponse.116'

      Sidekiq.logger.error(JSON.parse(response.body))
      true
    end

    def patron_linked_resources_fields(item_details = {})
      case item_details
      when ->(h) { h[:blockList] }
        ["blockList{*,#{ITEM_RESOURCES},block{description}}"]
      when ->(h) { h[:circRecordList] }
        ["circRecordList{*,#{ITEM_RESOURCES}}"]
      when ->(h) { h[:holdRecordList] }
        ["holdRecordList{*,#{ITEM_RESOURCES}}"]
      when ->(h) { h[:address1] }
        ['address1']
      when ->(h) { h[:all] }
        [
          'blockList{*}',
          'holdRecordList{*}',
          'circRecordList{*}'
        ]
      else
        ['alternateID']
      end
    end

    def authenticated_request(path, headers: {}, **other)
      response = request(path, headers: headers, **other)
      start = DateTime.now

      while records_in_use?(response) && time_left_to_request_again?(start)
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
