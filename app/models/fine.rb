# frozen_string_literal: true

class Fine
  include BibRecord

  attr_reader :record

  FINE_STATUS = {
    OVERDUE: 'Overdue materials',
    HOLD: 'Fee for placing a hold',
    CHARGE: 'Fee for checking out a book',
    PRIVILEGE: 'Fee for library card',
    MISC: 'Miscellaneous charges',
    LOST: 'Fee for lost materials',
    DAMAGE: 'Fee for damaged materials',
    RESERVEOVD: 'Overdue Reserves charge',
    RECALLOVD: 'Recall overdue',
    PROCESSFEE: 'Process fee attached to bills',
    REFERRAL: 'Fee for sending patron bills to collection agency',
    ILLDOCDEL: 'Fee for interlibrary loan document delivery',
    LOSTCARD: 'Lost Library card replacement',
    JOURNALOVD: 'Non barcoded journals',
    PRESUMELST: 'Presumed lost',
    ICPOVERDUE: 'ICPOVERDUE',
    LOSTMICRO: 'Lost microfilm fee',
    REBIND: 'For LOST books replaced with paperback',
    SPECPERMOV: 'Overdue special permission',
    NOFINE: 'No fines charges',
    PHOTOCOPY: 'Photocopies',
    CARRELKEY: 'Fee for a lost carrel key',
    OLDOVERDUE: 'Overdue materials (from ICP)',
    MISSINGPRT: 'Fee for item returned with missing part',
    VIDEOOVRD: 'Fee for overdue videos',
    TECHOVRD: 'Fee for overdue technology',
    ZBURCHGBAC: 'Fee for Bursar charge back',
    ZBILLRSTOR: 'Outstanding fees incorrectly marked as paid',
    REPAIRPROC: 'Processing fee for repair of equipment damaged by borrowers',
    EQUPREPAIR: 'Fee for repair costs of equipment damaged by borrowers'
  }.with_indifferent_access.freeze

  NO_TITLE_TEXT = 'NOT ASSOCIATED WITH AN ITEM'

  def initialize(record)
    @record = record
  end

  def title
    bib['title'] || NO_TITLE_TEXT
  end

  def owed_amount
    fields['owed']['amount'].to_d
  end

  def status_code
    fields.dig('block', 'key')
  end

  def status_human
    FINE_STATUS[status_code] || status_code
  end

  def bill_date
    Time.zone.parse(fields['billDate']) if fields['billDate']
  end

  private

    def fields
      record['fields']
    end
end
