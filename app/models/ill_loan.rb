# frozen_string_literal: true

class IllLoan
  FIELD_TYPES = {
    'Book' => 'BOOK',
    'Conference proceeding' => 'CONF',
    'Report' => 'RPRT',
    'Thesis/Dissertation' => 'THES'
  }.freeze

  def initialize(record)
    @record = record
  end

  def title
    record['LoanTitle']
  end

  def author
    record['LoanAuthor']
  end

  def date
    record['LoanDate']
  end

  def type
    doc_type = record['DocumentType']
    FIELD_TYPES.key?(doc_type) ? FIELD_TYPES[doc_type] : 'GEN'
  end

  def identifier
    record['ISSN']
  end

  def edition
    record['LoanEdition']
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
      case status
      when 'Customer Notified via E-Mail'
        'Available for Pickup'
      when 'Awaiting Recalled Processing'
        'Recalled, Please Return ASAP'
      when 'Checked Out to Customer'
        overdue_display(status)
      when /Renewed by/
        overdue_display(status)
      else
        'Processing'
      end
    end

    def overdue_display(status_to_display)
      if due_date.present? && (due_date < Date.today)
        'Overdue'
      else
        status_to_display
      end
    end
end
