# frozen_string_literal: true

class IllLoan
  def initialize(record)
    @record = record
  end

  def title
    record['LoanTitle']
  end

  def author
    record['LoanAuthor'].split(',').reverse.collect(&:strip).join(' ')
  end

  def status
    record['TransactionStatus']
  end

  def due_date
    record['DueDate']
  end

  def creation_date
    record['CreationDate']
  end

  private

    attr_accessor :record
end
