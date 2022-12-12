# frozen_string_literal: true

class IllLoan
  def initialize(record)
    @record = record
  end

  def title
    record['LoanTitle']
  end

  def author
    record['LoanAuthor']
  end

  def status
    record['TransactionStatus']
  end

  def due_date
    record['DueDate']&.to_datetime
  end

  def creation_date
    record['CreationDate']&.to_datetime
  end

  private

    attr_accessor :record
end
