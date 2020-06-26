class SirsiResponse::Error
  attr_reader :html, :log

  SIRSI_RESPONSE_TRANSLATIONS = {
      "hatErrorResponse.141": 'Denied: Renewal limit reached, cannot be renewed.',
      "hatErrorResponse.7703": 'Denied: Renewal limit reached, cannot be renewed.',
      "hatErrorResponse.105": 'Denied: Item has been recalled, cannot be renewed.',
      "hatErrorResponse.252": 'Denied: Item has holds, cannot be renewed.',
      "hatErrorResponse.46": 'Denied: Item on reserve, cannot be renewed.',
      "unhandledException": 'Denied: Item cannot be renewed.'
  }.with_indifferent_access

  def initialize(error_message_raw: ,symphony_client:, symphony_call:, key:, session_token:, bib_type:)
    @log = error_message_raw
    display_error = make_human_friendly_response

    parsed_response = SymphonyClientParser::parsed_response(symphony_client, symphony_call, key, session_token)
    klass = bib_type.to_s.classify.constantize
    bib_record = klass.new parsed_response


    @html = RedisJobsController.render template: 'sirsi_response/error',
                                       layout: false,
                                       locals: { id: key,
                                                 title: bib_record.title,
                                                 display_error: display_error }
  end

  private
  def make_human_friendly_response
    SIRSI_RESPONSE_TRANSLATIONS[@log&.dig('messageList')&.first&.dig('code')] ||
        @log&.dig('messageList')&.first&.dig('message') ||
        'Something went wrong'
  end
end