# frozen_string_literal: true

class IllLoan
  def initialize(record)
    @record = record
  end

  def title
    record['LoanTitle'] || record['PhotoArticleTitle']
  end

  def author
    (record['LoanAuthor'] || record['PhotoArticleAuthor']).split(',').reverse.collect(&:strip).join(' ')
  end

  def status
    record['TransactionStatus']
  end

  def due_date
    record['DueDate']
  end

  private

    attr_accessor :record
end
