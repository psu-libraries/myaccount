# frozen_string_literal: true

# Model for holds in Symphony
class Hold
  include BibRecord

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def to_partial_path
    'requests/request'
  end

  def key
    record['key']
  end

  def patron_key
    fields['patron']['key']
  end

  def resource
    record['resource']
  end

  def status
    fields['status']
  end

  def ready_for_pickup?
    status == 'BEING_HELD'
  end

  def queue_position
    fields['queuePosition']
  end

  def queue_length
    fields['queueLength']
  end

  def expiration_date
    Time.zone.parse(fields['expirationDate']) if fields['expirationDate']
  end

  def placed_date
    Time.zone.parse(fields['placedDate']) if fields['placedDate']
  end

  def fill_by_date
    Time.zone.parse(fields['fillByDate']) if fields['fillByDate']
  end

  def waitlist_position
    return 'Unknown' if queue_position.nil? && queue_length.nil?

    "#{queue_position} of #{queue_length}"
  end

  def pickup_library
    fields['pickupLibrary']['key']
  end

  def placed_library
    fields['placedLibrary']['key']
  end

  def library
    code = item&.dig('library', 'key')
    code ||= bib['callList'].first&.dig('fields', 'library', 'key')

    code
  end

  private

  def fields
    record['fields']
  end
end