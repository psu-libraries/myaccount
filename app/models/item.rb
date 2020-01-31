# frozen_string_literal: true

# Model for item-level information in Symphony
class Item
  include BibRecord

  attr_reader :record

  def initialize(record)
    @record = record
  end

  private

    def fields
      record['fields']
    end

    def item
      record['fields']
    end
end
