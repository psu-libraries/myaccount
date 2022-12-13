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
    status_display(record['TransactionStatus'])
  end

  def due_date
    record['DueDate']&.to_datetime
  end

  def creation_date
    record['CreationDate']&.to_datetime
  end

  private

    attr_accessor :record

    def status_display(status)
      if status == 'Customer Notified via E-mail'
        'Available for Pickup'
      elsif status == 'Checked Out to Customer'
        status
      elsif status.match(/Renewed by/)
        status
      else
        'Processing'
      end
    end
end
