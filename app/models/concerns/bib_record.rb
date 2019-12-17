# frozen_string_literal: true

# Common accessors into bib item data
module BibRecord
  ITEM_TYPE = {
    "UNKNOWN": 'Unknown',
    "ILL": 'ILL Item',
    "INSTR-MATL": 'Instructional Material',
    "JUVENILEBK": 'Book, Juvenile',
    "BOOK": 'Book',
    "BNDSER-HY": 'Bound Journal',
    "MICROFORM": 'Microfilm, Microfiche, etc.',
    "NEWSPAPER": 'Newspaper',
    "E-MEDIA": 'Computer Disc, etc.',
    "REF-ITEM": 'Book, Reference',
    "ANY": 'ANY',
    "ARCHIVES": 'Archives & Manuscripts',
    "AUDIO": 'Audio Material',
    "BNDSER-DSL": 'Bound Journal',
    "LAPTOP": 'Laptop Computer',
    "FOLDER": 'File Folder',
    "MAP": 'Map',
    "MULTIMEDIA": 'Multimedia Material',
    "ONLINE": 'Online Resource',
    "PERIODICAL": 'Bound Journal',
    "SCORE": 'Music Score',
    "THESIS-D": 'Penn State Thesis (Doctoral)',
    "THESIS-B": 'Penn State Thesis (Bachelors)',
    "THESIS-M": 'Penn State Thesis (Masters)',
    "VIDEO": 'Video Material',
    "PALCI": 'PALCI',
    "REPORTER": 'Reporter',
    "STATUTE": 'Statute',
    "CARRELKEY": 'Carrel Key Pattee',
    "EBOOKREADR": 'E-book Reader',
    "BOOKSPEC": 'Book for Use In Library Only',
    "ATLAS": 'Atlas',
    "EQUIP4HR": 'Equipment - 4 hour loan',
    "EQUIP24HR": 'Equipment - 24 hour loan',
    "EQUIP3DAY": 'Equipment - 3 day loan',
    "EQUIP5DAY": 'Equipment - 5 day loan',
    "EQUIP7DAY": 'Equipment - 7 day loan',
    "EQUIP14DAY": 'Equipment - 14 day loan',
    "BOOKFLOAT": 'Book',
    "SERIAL": 'Book',
    "MAPSPEC": 'Map for Use In Library Only',
    "SCORESPEC": 'Music Score for Use in Library Only',
    "EQUIP24FEE": 'Equipment - 24 hour loan with fees',
    "PERIODSPEC": 'Bound Journal, ask at service desk for 24 hour loan'
  }.with_indifferent_access

  def catkey
    fields.dig('bib', 'key') || item.dig('bib', 'key')
  end

  def item_type_code
    item.dig('itemType', 'key')
  end

  def item_type_human
    ITEM_TYPE[item_type_code] || item_type_code
  end

  def title
    bib['title']
  end

  def author
    bib['author']
  end

  def resource
    fields.dig('item', 'resource')
  end

  def item_key
    fields.dig('item', 'key')
  end

  private

    def item
      fields.dig('item', 'fields') || {}
    end

    def bib
      fields.dig('bib', 'fields') || fields.dig('item', 'fields', 'bib', 'fields') || {}
    end

    def call
      item.dig('call', 'fields') || {}
    end
end
