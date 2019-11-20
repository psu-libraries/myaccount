# frozen_string_literal: true

# Class to model Patron information
class Patron
  attr_reader :record

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
    @checkouts ||= fields['circRecordList'].map { |checkout| Checkout.new(checkout) }
  end

  def holds
    @holds ||= fields['holdRecordList'].map { |hold| Hold.new(hold) }
  end

  private

    def fields
      record['fields']
    end
end
