# frozen_string_literal: true

# Model for holds in Symphony
class Hold
  include BibRecord

  PICKUP_LOCATION_REQUESTED = Settings.pickup_locations.to_h.invert

  PICKUP_LOCATION_ACTUAL = {
    ABINGTON: 'Abington',
    ACQ_DSL: 'Acquisitions (Law Schools)',
    ACQUISTNS: 'Acquisitions (UP)',
    ALTOONA: 'Altoona',
    BEAVER: 'Beaver',
    BEHREND: 'Erie',
    BERKS: 'Berks',
    BRANDYWINE: 'Brandywine',
    "DSL-CARL": 'Dickinson Law (Carlisle)',
    "DSL-UP": 'Penn State Law (UP)',
    DUBOIS: 'DuBois',
    FAYETTE: 'Fayette',
    GALLEGHENY: 'Greater Allegheny',
    GREATVLY: 'Great Valley',
    HARRISBURG: 'Harrisburg',
    HAZLETON: 'Hazleton',
    HERSHEY: 'Hershey (College of Medicine)',
    LEHIGHVLY: 'Lehigh Valley',
    MONTALTO: 'Mont Alto',
    NEWKEN: 'New Kensington',
    ONLINE: 'Online Resource',
    SCHUYLKILL: 'Schuylkill',
    "SERIAL-SRV": 'Acquisitions (UP)',
    SHENANGO: 'Shenango',
    "UP-ANNEX": 'Library Storage',
    "UP-ARCHIT": 'Architecture & Landscape Architecture Library (UP)',
    "UP-ARTSHUM": 'Arts & Humanities Library (Pattee)',
    "UP-BUSINES": 'Business Library (Paterno)',
    "UP-EMS": 'Earth & Mineral Sciences Library (UP)',
    "UP-ENGIN": 'Engineering Library (UP)',
    "UP-GATEWAY": 'Global Gateways',
    "UP-LIFESCI": 'Life Sciences Library (Paterno)',
    "UP-MAPS": 'Maps and Geospatial Information (Pattee)',
    "UP-MEDICAL": 'College of Medicine (UP)',
    "UP-MICRO": 'Microforms Library (Paterno)',
    "UP-OFFICE": 'Employee Office',
    "UP-PAMS": 'Physical & Mathematical Sciences Library (UP)',
    "UP-PAT": 'Pattee Library and Paterno Library Stacks',
    "UP-SOCSCI": 'Social Sciences & Education Library (Paterno)',
    "UP-EDUBEHV": 'Social Sciences & Education Library (Paterno)',
    "UP-SPECCOL": 'Special Collections Library (Paterno)',
    WILKESBAR: 'Wilkes-Barre',
    WITHDRAWN: 'Withdrawn',
    WORLD: 'World Campus',
    WSCRANTON: 'Scranton',
    XTERNAL: 'Associated Libraries',
    YORK: 'York'
  }.with_indifferent_access

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def key
    record['key']
  end

  def patron_key
    fields['patron']['key']
  end

  def ready_for_pickup?
    status_code == 'BEING_HELD'
  end

  def pickup_library_human
    PICKUP_LOCATION_ACTUAL[pickup_library_code] || pickup_library_code
  end

  def expiration_date
    Time.zone.parse fields['expirationDate'] if fields['expirationDate']
  end

  def fill_by_date
    Time.zone.parse fields['fillByDate'] if fields['fillByDate']
  end

  def queue_position
    fields['queuePosition']
  end

  def suspend_begin_date
    Time.zone.parse fields['suspendBeginDate'] if fields['suspendBeginDate']
  end

  def suspend_end_date
    Time.zone.parse fields['suspendEndDate'] if fields['suspendEndDate']
  end

  def status_code
    fields['status']
  end

  private

    def fields
      record['fields']
    end

    def pickup_library_code
      fields.dig('pickupLibrary', 'key') || fields.dig('library', 'key')
    end
end
