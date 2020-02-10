# frozen_string_literal: true

FactoryBot.define do
  factory :bib do

    factory :bib_with_volumetrics do
      body {
        {"resource"=>"/catalog/bib",
         "key"=>"12747187",
         "fields"=>
             {"shadowed"=>false,
              "author"=>"Hill Street blues (Television program)",
              "titleControlNumber"=>"ocn880677198",
              "catalogDate"=>nil,
              "catalogFormat"=>{"resource"=>"/policy/catalogFormat", "key"=>"VM"},
              "modifiedDate"=>"2018-08-04",
              "systemModifiedDate"=>"2020-02-04T15:46:00-05:00",
              "title"=>"Hill Street blues. The complete series",
              "callList"=>
                  [{"resource"=>"/catalog/call",
                    "key"=>"12747187:8",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"bklet.",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD bklet.",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:8:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:8"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000077108494",
                                    "circulate"=>false,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"CHECKEDOUT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}},
                   {"resource"=>"/catalog/call",
                    "key"=>"12747187:1",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"v.1",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD v.1",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:1:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:1"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000075504342",
                                    "circulate"=>false,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"CHECKEDOUT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}},
                   {"resource"=>"/catalog/call",
                    "key"=>"12747187:2",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"v.2",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD v.2",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:2:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:2"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000077108531",
                                    "circulate"=>false,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"CHECKEDOUT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}},
                   {"resource"=>"/catalog/call",
                    "key"=>"12747187:3",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"v.3",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD v.3",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:3:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:3"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000077108562",
                                    "circulate"=>false,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"CHECKEDOUT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}},
                   {"resource"=>"/catalog/call",
                    "key"=>"12747187:4",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"v.4",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD v.4",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:4:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:4"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000077108555",
                                    "circulate"=>false,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"CHECKEDOUT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}},
                   {"resource"=>"/catalog/call",
                    "key"=>"12747187:5",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"v.5",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD v.5",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:5:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:5"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000077108548",
                                    "circulate"=>false,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"CHECKEDOUT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}},
                   {"resource"=>"/catalog/call",
                    "key"=>"12747187:6",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"v.6",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD v.6",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:6:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:6"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000077108524",
                                    "circulate"=>false,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"CHECKEDOUT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}},
                   {"resource"=>"/catalog/call",
                    "key"=>"12747187:7",
                    "fields"=>
                        {"library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                         "callNumber"=>"PN1992.77.H485 2014 DVD",
                         "shadowed"=>false,
                         "volumetric"=>"v.7",
                         "dispCallNumber"=>"PN1992.77.H485 2014 DVD v.7",
                         "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                         "itemList"=>
                             [{"resource"=>"/catalog/item",
                               "key"=>"12747187:7:1",
                               "fields"=>
                                   {"call"=>{"resource"=>"/catalog/call", "key"=>"12747187:7"},
                                    "mediaDesk"=>nil,
                                    "itemType"=>{"resource"=>"/policy/itemType", "key"=>"VIDEO"},
                                    "library"=>{"resource"=>"/policy/library", "key"=>"BEHREND"},
                                    "shadowed"=>false,
                                    "homeLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"MEDIA-BD"},
                                    "copyNumber"=>1,
                                    "bib"=>{"resource"=>"/catalog/bib", "key"=>"12747187"},
                                    "barcode"=>"000077108500",
                                    "circulate"=>true,
                                    "currentLocation"=>
                                        {"resource"=>"/policy/location", "key"=>"INTRANSIT"}}}],
                         "classification"=>
                             {"resource"=>"/policy/classification", "key"=>"LC"}}}],
              "createDate"=>"2014-07-16"}}
      }


      initialize_with { new(attributes[:body]) }
    end
  end
end

