# frozen_string_literal: true

# Model for the Checkouts page
class Checkout
  include BibRecord

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def key
    record['key']
  end

  def status
    fields['status']
  end

  def due_date
    fields['dueDate'] && Time.zone.parse(fields['dueDate'])
  end

  def recall_due_date
    fields['recallDueDate'] && Time.zone.parse(fields['recallDueDate'])
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

  def renewal_date
    Time.zone.parse(fields['renewalDate']) if fields['renewalDate']
  end

  def overdue?
    fields['overdue']
  end

  def accrued
    fields.dig('estimatedOverdueAmount', 'amount').to_d
  end

  def renewal_count
    fields['renewalCount'] || 0
  end

  private

    def fields
      record['fields']
    end
end
