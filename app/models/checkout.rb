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

  def due_date
    recall_due_date || original_due_date
  end

  def original_due_date
    fields['dueDate'] && Time.zone.parse(fields['dueDate'])
  end

  def recall_due_date
    fields['recallDueDate'] && Time.zone.parse(fields['recallDueDate'])
  end

  def days_overdue
    return 0 unless overdue?

    ((Time.zone.now - due_date).to_i / 60 / 60 / 24) + 1
  end

  def checkout_date
    Time.zone.parse(fields['checkOutDate'])
  end

  def recalled_date
    Time.zone.parse(fields['recalledDate']) if fields['recalledDate']
  end

  def recalled?
    recalled_date.present?
  end

  def claims_returned_date
    Time.zone.parse(fields['claimsReturnedDate']) if fields['claimsReturnedDate']
  end

  def claims_returned?
    claims_returned_date.present?
  end

  def patron_key
    fields['patron']['key']
  end

  def overdue?
    fields['overdue']
  end

  def accrued
    fields.dig('estimatedOverdueAmount', 'amount').to_d
  end

  def days_remaining
    return 0 if overdue?

    (due_date.to_date - Time.zone.now.to_date).to_i
  end

  def library
    fields['library']['key']
  end

  def renewal_count
    fields['renewalCount'] || 0
  end

  private

    def fields
      record['fields']
    end
end
