# frozen_string_literal: true

# Model for the Checkouts page
class Checkout
  include BibRecord

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def to_partial_path
    'checkouts/checkout'
  end

  def key
    record['key']
  end

  def status
    fields['status']
  end

  def recalled_date
    Time.zone.parse(fields['recalledDate']) if fields['recalledDate']
  end

  def recalled?
    recalled_date.present?
  end

  def patron_key
    fields['patron']['key']
  end

  def overdue?
    fields['overdue']
  end

  def library
    fields['library']['key']
  end

  private

    def fields
      record['fields']
    end
end
