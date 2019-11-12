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
    record['fields']['barcode']
  end

  def name
    record['fields']['firstName']
  end
end
