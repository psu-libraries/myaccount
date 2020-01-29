# frozen_string_literal: true

# Class to model Patron information
class Patron
  attr_reader :record

  PATRON_STANDING_ALERTS = {
    BARRED: 'The user is BARRED.',
    BLOCKED: 'The user is BLOCKED.',
    DELINQUENT: 'The user is DELINQUENT.',
    COLLECTION: 'The user has been sent to collection agency.'
  }.with_indifferent_access

  def initialize(record)
    @record = record
  end

  def key
    record['key']
  end

  def barcode
    fields['barcode']
  end

  def first_name
    fields['firstName']
  end

  def last_name
    fields['lastName']
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def checkouts
    @checkouts ||= fields['circRecordList']
      .map { |checkout| Checkout.new(checkout) }
      .select { |checkout| checkout.status == 'ACTIVE' }
  end

  def holds
    @holds ||= fields['holdRecordList'].map { |hold| Hold.new(hold) }
  end

  def fines
    @fines ||= fields['blockList'].map { |fine| Fine.new(fine) }
  end

  def stale?
    record == { 'messageList' => [{ 'code' => 'sessionTimedOut', 'message' => 'The session has timed out.' }] }
  end

  def standing_human
    PATRON_STANDING_ALERTS[standing_code] || ''
  end

  private

    def fields
      record['fields']
    end

    def standing_code
      fields.dig('standing', 'key')
    end
end
