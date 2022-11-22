# frozen_string_literal: true

# Model for Symphony record representing an ILLiad Transaction
class IllTransaction
  def initialize(patron, bib_info)
    @patron = patron
    @bib_info = bib_info
  end

  def request_type
    'Loan'
  end

  def process_type
    'Borrowing'
  end

  def loan_author
    bib&.dig 'author'
  end

  def loan_title
    bib&.dig 'title'
  end

  def isbn
    tag('020')
      &.select { |t| t['code'] == 'a' }
      &.first
      &.dig('data')
  end

  def username
    @patron.id
  end

  private

    def bib
      record['fields']
    end

    def fields
      bib&.dig 'bib', 'fields'
    end

    def record
      @bib_info.record
    end

    def tag(tag)
      fields
        &.select { |field| field['tag'] == tag }
        &.map { |t| t['subfields'] }
        &.flatten
    end
end
