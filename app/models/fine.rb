# frozen_string_literal: true

class Fine
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def fee
    fields['owed']['amount'].to_d
  end

  private

    def fields
      record['fields']
    end
end
