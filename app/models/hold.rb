# frozen_string_literal: true

# Model for holds in Symphony
class Hold
  include BibRecord

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def to_partial_path
    'holds/hold'
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

  private

  def fields
    record['fields']
  end
end