# frozen_string_literal: true

FactoryBot.define do
  factory :bib do
    factory :bib_without_holdables do
      initialize_with {
        new(body)
      }

      body {
        {
          'resource' => '/catalog/bib',
          'key' => '26141494',
          'fields' => {
            'shadowed' => false,
            'author' => 'Diamond, Jared M. author.',
            'titleControlNumber' => 'l2018952825',
            'catalogDate' => '2019-05-28',
            'catalogFormat' => {
              'resource' => '/policy/catalogFormat', 'key' => 'MARC'
            },
            'modifiedDate' => '2019-12-08',
            'systemModifiedDate' => '2020-02-04T15:11:00-05:00',
            'title' => 'Upheaval : turning points for nations in crisis',
            'callList' => [{
              'resource' => '/catalog/call',
              'key' => '26141494:4',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                },
                'callNumber' => 'HN13.D52 2019',
                'shadowed' => false,
                'volumetric' => nil,
                'dispCallNumber' => 'HN13.D52 2019',
                'bib' => {
                  'resource' => '/catalog/bib', 'key' => '26141494'
                },
                'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '26141494:4:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '26141494:4'
                    },
                    'mediaDesk' => nil,
                    'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'BOOK'
                    },
                    'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    },
                    'shadowed' => false,
                    'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'LEISURE-PA'
                    },
                    'copyNumber' => 1,
                    'bib' => {
                      'resource' => '/catalog/bib', 'key' => '26141494'
                    },
                    'barcode' => '000080793182',
                    'circulate' => false,
                    'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                },
                               {
                                 'resource' => '/catalog/item',
                                 'key' => '26141494:4:2',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '26141494:4'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'BOOK'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'UP-PAT'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'PATERNO-2'
                                   },
                                   'copyNumber' => 2,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '26141494'
                                   },
                                   'barcode' => '000081297085',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'ILLEND'
                                   }
                                 }
                               }],
                'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              }
            },
                           {
                             'resource' => '/catalog/call',
                             'key' => '26141494:6',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'ALTOONA'
                               },
                               'callNumber' => 'HN13.D52 2019',
                               'shadowed' => false,
                               'volumetric' => nil,
                               'dispCallNumber' => 'HN13.D52 2019',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '26141494'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '26141494:6:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '26141494:6'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'BOOKFLOAT'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'ALTOONA'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'STACKS-AA'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '26141494'
                                   },
                                   'barcode' => '000081321605',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'ILLEND'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '26141494:3',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'HN13.D52 2019',
                               'shadowed' => false,
                               'volumetric' => nil,
                               'dispCallNumber' => 'HN13.D52 2019',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '26141494'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '26141494:3:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '26141494:3'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'BOOKFLOAT'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'STACKS-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '26141494'
                                   },
                                   'barcode' => '000081287932',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'ILLEND'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '26141494:5',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'WSCRANTON'
                               },
                               'callNumber' => 'HN13.D52 2019',
                               'shadowed' => false,
                               'volumetric' => nil,
                               'dispCallNumber' => 'HN13.D52 2019',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '26141494'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '26141494:5:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '26141494:5'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'BOOKFLOAT'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'WSCRANTON'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'STACKS-WS'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '26141494'
                                   },
                                   'barcode' => '000081402335',
                                   'circulate' => true,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'INTRANSIT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '26141494:1',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'WSCRANTON'
                               },
                               'callNumber' => 'SN15687372',
                               'shadowed' => false,
                               'volumetric' => nil,
                               'dispCallNumber' => 'SN15687372',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '26141494'
                               },
                               'itemList' => [],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           }],
            'createDate' => '2019-03-11'
          }
        }
      }
    end

    factory :bib_with_no_holdable_locations do
      initialize_with {
        new(body)
      }

      body {
        {
          'resource' => '/catalog/bib',
          'key' => '26141494',
          'fields' => {
            'shadowed' => false,
            'author' => 'Diamond, Jared M. author.',
            'titleControlNumber' => 'l2018952825',
            'catalogDate' => '2019-05-28',
            'catalogFormat' => {
              'resource' => '/policy/catalogFormat', 'key' => 'MARC'
            },
            'modifiedDate' => '2019-12-08',
            'systemModifiedDate' => '2020-02-04T15:11:00-05:00',
            'title' => 'Upheaval : turning points for nations in crisis',
            'callList' => [{
              'resource' => '/catalog/call',
              'key' => '26141494:4',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                },
                'callNumber' => 'HN13.D52 2019',
                'shadowed' => false,
                'volumetric' => nil,
                'dispCallNumber' => 'HN13.D52 2019',
                'bib' => {
                  'resource' => '/catalog/bib', 'key' => '26141494'
                },
                'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '26141494:4:2',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '26141494:4'
                    },
                    'mediaDesk' => nil,
                    'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'BOOK'
                    },
                    'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    },
                    'shadowed' => false,
                    'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'PATERNO-2'
                    },
                    'copyNumber' => 2,
                    'bib' => {
                      'resource' => '/catalog/bib', 'key' => '26141494'
                    },
                    'barcode' => '000081297085',
                    'circulate' => false,
                    'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'ILLEND'
                    }
                  }
                }],
                'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              }
            },
                           {
                             'resource' => '/catalog/call',
                             'key' => '26141494:6',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'ALTOONA'
                               },
                               'callNumber' => 'HN13.D52 2019',
                               'shadowed' => false,
                               'volumetric' => nil,
                               'dispCallNumber' => 'HN13.D52 2019',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '26141494'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '26141494:6:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '26141494:6'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'BOOKFLOAT'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'ALTOONA'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'STACKS-AA'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '26141494'
                                   },
                                   'barcode' => '000081321605',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'ILLEND'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '26141494:3',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'HN13.D52 2019',
                               'shadowed' => false,
                               'volumetric' => nil,
                               'dispCallNumber' => 'HN13.D52 2019',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '26141494'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '26141494:3:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '26141494:3'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'BOOKFLOAT'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'STACKS-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '26141494'
                                   },
                                   'barcode' => '000081287932',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'ILLEND'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '26141494:1',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'WSCRANTON'
                               },
                               'callNumber' => 'SN15687372',
                               'shadowed' => false,
                               'volumetric' => nil,
                               'dispCallNumber' => 'SN15687372',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '26141494'
                               },
                               'itemList' => [],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           }],
            'createDate' => '2019-03-11'
          }
        }
      }
    end

    factory :bib_with_holdables do
      initialize_with {
        new(body)
      }

      body {
        {
          'resource' => '/catalog/bib',
          'key' => '12747187',
          'fields' => {
            'shadowed' => false,
            'author' => 'Hill Street blues (Television program)',
            'titleControlNumber' => 'ocn880677198',
            'catalogDate' => nil,
            'catalogFormat' => {
              'resource' => '/policy/catalogFormat', 'key' => 'VM'
            },
            'modifiedDate' => '2018-08-04',
            'systemModifiedDate' => '2020-02-04T15:46:00-05:00',
            'title' => 'Hill Street blues. The complete series',
            'callList' => [{
              'resource' => '/catalog/call',
              'key' => '12747187:8',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'BEHREND'
                },
                'callNumber' => 'PN1992.77.H485 2014 DVD',
                'shadowed' => false,
                'volumetric' => 'bklet.',
                'dispCallNumber' => 'PN1992.77.H485 2014 DVD bklet.',
                'bib' => {
                  'resource' => '/catalog/bib', 'key' => '12747187'
                },
                'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '12747187:8:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '12747187:8'
                    },
                    'mediaDesk' => nil,
                    'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    },
                    'library' => {
                      'resource' => '/policy/library', 'key' => 'BEHREND'
                    },
                    'shadowed' => false,
                    'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                    },
                    'copyNumber' => 1,
                    'bib' => {
                      'resource' => '/catalog/bib', 'key' => '12747187'
                    },
                    'barcode' => '000077108494',
                    'circulate' => false,
                    'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }],
                'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              }
            },
                           {
                             'resource' => '/catalog/call',
                             'key' => '12747187:1',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'PN1992.77.H485 2014 DVD',
                               'shadowed' => false,
                               'volumetric' => 'v.1',
                               'dispCallNumber' => 'PN1992.77.H485 2014 DVD v.1',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '12747187'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '12747187:1:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '12747187:1'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'VIDEO'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '12747187'
                                   },
                                   'barcode' => '000075504342',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '12747187:2',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'PN1992.77.H485 2014 DVD',
                               'shadowed' => false,
                               'volumetric' => 'v.2',
                               'dispCallNumber' => 'PN1992.77.H485 2014 DVD v.2',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '12747187'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '12747187:2:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '12747187:2'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'VIDEO'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '12747187'
                                   },
                                   'barcode' => '000077108531',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '12747187:3',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'PN1992.77.H485 2014 DVD',
                               'shadowed' => false,
                               'volumetric' => 'v.3',
                               'dispCallNumber' => 'PN1992.77.H485 2014 DVD v.3',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '12747187'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '12747187:3:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '12747187:3'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'VIDEO'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '12747187'
                                   },
                                   'barcode' => '000077108562',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '12747187:4',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'PN1992.77.H485 2014 DVD',
                               'shadowed' => false,
                               'volumetric' => 'v.4',
                               'dispCallNumber' => 'PN1992.77.H485 2014 DVD v.4',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '12747187'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '12747187:4:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '12747187:4'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'VIDEO'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '12747187'
                                   },
                                   'barcode' => '000077108555',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '12747187:5',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'PN1992.77.H485 2014 DVD',
                               'shadowed' => false,
                               'volumetric' => 'v.5',
                               'dispCallNumber' => 'PN1992.77.H485 2014 DVD v.5',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '12747187'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '12747187:5:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '12747187:5'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'VIDEO'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '12747187'
                                   },
                                   'barcode' => '000077108548',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '12747187:6',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'PN1992.77.H485 2014 DVD',
                               'shadowed' => false,
                               'volumetric' => 'v.6',
                               'dispCallNumber' => 'PN1992.77.H485 2014 DVD v.6',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '12747187'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '12747187:6:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '12747187:6'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'VIDEO'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '12747187'
                                   },
                                   'barcode' => '000077108524',
                                   'circulate' => false,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           },
                           {
                             'resource' => '/catalog/call',
                             'key' => '12747187:7',
                             'fields' => {
                               'library' => {
                                 'resource' => '/policy/library', 'key' => 'BEHREND'
                               },
                               'callNumber' => 'PN1992.77.H485 2014 DVD',
                               'shadowed' => false,
                               'volumetric' => 'v.7',
                               'dispCallNumber' => 'PN1992.77.H485 2014 DVD v.7',
                               'bib' => {
                                 'resource' => '/catalog/bib', 'key' => '12747187'
                               },
                               'itemList' => [{
                                 'resource' => '/catalog/item',
                                 'key' => '12747187:7:1',
                                 'fields' => {
                                   'call' => {
                                     'resource' => '/catalog/call', 'key' => '12747187:7'
                                   },
                                   'mediaDesk' => nil,
                                   'itemType' => {
                                     'resource' => '/policy/itemType', 'key' => 'VIDEO'
                                   },
                                   'library' => {
                                     'resource' => '/policy/library', 'key' => 'BEHREND'
                                   },
                                   'shadowed' => false,
                                   'homeLocation' => {
                                     'resource' => '/policy/location', 'key' => 'MEDIA-BD'
                                   },
                                   'copyNumber' => 1,
                                   'bib' => {
                                     'resource' => '/catalog/bib', 'key' => '12747187'
                                   },
                                   'barcode' => '000077108500',
                                   'circulate' => true,
                                   'currentLocation' => {
                                     'resource' => '/policy/location', 'key' => 'INTRANSIT'
                                   }
                                 }
                               }],
                               'classification' => {
                                 'resource' => '/policy/classification', 'key' => 'LC'
                               }
                             }
                           }],
            'createDate' => '2014-07-16'
          }
        }
      }
    end
    factory :bib_with_dupe_call_number_volumetrics do
      initialize_with {
        new(body)
      }

      body {
        {
          'resource' => '/catalog/bib', 'key' => '7517385', 'fields' => {
            'shadowed' => false, 'author' => 'Columbus, Chris.', 'titleControlNumber' => 'i9780780674318', 'catalogDate' => '2011-12-07', 'catalogFormat' => {
              'resource' => '/policy/catalogFormat', 'key' => 'VM'
            }, 'modifiedDate' => '2019-09-09', 'systemModifiedDate' => '2020-02-24T15:33:00-05:00', 'title' => 'Harry Potter complete 8-film collection [videorecording]', 'callList' => [{
              'resource' => '/catalog/call',
              'key' => '7517385:17',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.1', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.1', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:17:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:17'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076647505', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 1.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:18',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.2', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.2', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:18:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:18'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076502217', 'circulate' => false, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 2.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:19',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.3', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.3', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:19:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:19'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076501944', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 3.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:20',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.4', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.4', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:20:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:20'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076502545', 'circulate' => false, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 4.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:21',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.5', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.5', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:21:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:21'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076502224', 'circulate' => false, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 5.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:22',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.6', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.6', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:22:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:22'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076502255', 'circulate' => false, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 6.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:23',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.7', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.7', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:23:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:23'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076502569', 'circulate' => false, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 7.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:24',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-PAT'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.8', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.8', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:24:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:24'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-PAT'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ATRIUM-DVD'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000076502552', 'circulate' => false, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 8.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:1',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ALTOONA'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.1', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.1', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:1:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:1'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ALTOONA'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000070921649', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 1.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:2',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ALTOONA'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.2', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.2', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:2:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:2'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ALTOONA'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000071879376', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 2.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:3',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ALTOONA'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.3', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.3', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:3:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:3'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ALTOONA'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000071879352', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 3.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:4',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ALTOONA'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.4', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.4', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:4:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:4'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ALTOONA'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000071879512', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 4.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:5',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ALTOONA'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.5', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.5', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:5:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:5'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ALTOONA'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000072006467', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 5.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:7',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ALTOONA'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.6', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.6', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:7:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:7'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ALTOONA'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000071879925', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 6.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:6',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ALTOONA'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.7', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.7', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:6:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:6'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ALTOONA'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000071879918', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-AA'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 7.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:26',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.1', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.1', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:26:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:26'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081451531', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 1.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:27',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.2', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.2', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:27:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:27'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081450824', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 2.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:28',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.3', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.3', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:28:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:28'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081451630', 'circulate' => false, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'CHECKEDOUT'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 3.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:29',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.4', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.4', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:29:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:29'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081451623', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 4.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:30',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.5', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.5', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:30:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:30'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081451616', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 5.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:31',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.6', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.6', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:31:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:31'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081451586', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 6.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:32',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.7', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.7', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:32:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:32'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081451494', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 7.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:33',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'DUBOIS'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.8', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.8', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:33:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:33'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'DUBOIS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000081451500', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-DS'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 8.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:10',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'SHENANGO'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.2', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.2', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:10:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:10'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'SHENANGO'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000074519859', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 2.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:11',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'SHENANGO'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.3', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.3', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:11:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:11'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'SHENANGO'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000074519620', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 3.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:12',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'SHENANGO'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.4', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.4', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:12:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:12'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'SHENANGO'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000074519774', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 4.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:13',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'SHENANGO'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.5', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.5', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:13:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:13'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'SHENANGO'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000074519583', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['DVD', 'disc', 5.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:14',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'SHENANGO'
                }, 'callNumber' => 'PN1995.9.F36H377 2011 DVD', 'shadowed' => false, 'volumetric' => 'disc.6', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.6', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:14:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:14'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'SHENANGO'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000074519866', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['disc', 6.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:15',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'SHENANGO'
                }, 'callNumber' => 'PN1995.9.F36H377 2011 DVD', 'shadowed' => false, 'volumetric' => 'disc.7', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.7', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:15:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:15'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'SHENANGO'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000074519767', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['disc', 7.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:16',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'SHENANGO'
                }, 'callNumber' => 'PN1995.9.F36H377 2011 DVD', 'shadowed' => false, 'volumetric' => 'disc.8', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.8', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '7517385:16:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '7517385:16'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'VIDEO'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'SHENANGO'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '7517385'
                    }, 'barcode' => '000074519712', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'MEDIA-SV'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['disc', 8.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '7517385:25',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ZREMOVED'
                }, 'callNumber' => 'PN1995.9.F36H377 2011', 'shadowed' => false, 'volumetric' => 'DVD disc.8', 'dispCallNumber' => 'PN1995.9.F36H377 2011 DVD disc.8', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '7517385'
                }, 'itemList' => [], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              }
            }], 'createDate' => '2011-11-01'
          }
        }
      }
    end

    factory :bib_with_multiple_non_volumetrics do
      initialize_with {
        new(body)
      }

      body {
        {
          'resource' => '/catalog/bib', 'key' => '15513', 'fields' => {
            'shadowed' => false, 'author' => 'Sangree, Anne C., editor.', 'titleControlNumber' => 'LIAS53120', 'catalogDate' => '1997-08-21', 'catalogFormat' => {
              'resource' => '/policy/catalogFormat', 'key' => 'MARC'
            }, 'modifiedDate' => '2019-05-26', 'systemModifiedDate' => '2020-02-13T11:20:00-05:00', 'title' => 'Elevations in Pennsylvania', 'callList' => [{
              'resource' => '/catalog/call',
              'key' => '15513:1',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'HARRISBURG'
                }, 'callNumber' => 'QE157.S26x', 'shadowed' => false, 'volumetric' => nil, 'dispCallNumber' => 'QE157.S26x', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '15513'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '15513:1:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '15513:1'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'BOOKFLOAT'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'HARRISBURG'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-HB3'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '15513'
                    }, 'barcode' => '000058006191', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-HB3'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => []
            }, {
              'resource' => '/catalog/call',
              'key' => '15513:9',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-MAPS'
                }, 'callNumber' => 'GB495.P4E4', 'shadowed' => false, 'volumetric' => nil, 'dispCallNumber' => 'GB495.P4E4', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '15513'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '15513:9:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '15513:9'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'BOOK'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-MAPS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-MP'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '15513'
                    }, 'barcode' => '000010591345', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-MP'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => []
            }, {
              'resource' => '/catalog/call',
              'key' => '15513:6',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'UP-EMS'
                }, 'callNumber' => 'QE157.P45', 'shadowed' => false, 'volumetric' => 'no.4', 'dispCallNumber' => 'QE157.P45 no.4', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '15513'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '15513:6:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '15513:6'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'BOOK'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'UP-EMS'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-EM'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '15513'
                    }, 'barcode' => '000022668905', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'STACKS-EM'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              },
              'naturalized_volumetric' => ['no', 4.0]
            }, {
              'resource' => '/catalog/call',
              'key' => '15513:11',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ZREMOVED'
                }, 'callNumber' => 'GB495.P5E4', 'shadowed' => false, 'volumetric' => nil, 'dispCallNumber' => 'GB495.P5E4', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '15513'
                }, 'itemList' => [], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'LC'
                }
              }
            }, {
              'resource' => '/catalog/call',
              'key' => '15513:10',
              'fields' => {
                'library' => {
                  'resource' => '/policy/library', 'key' => 'ONLINE'
                }, 'callNumber' => 'Electronic resource', 'shadowed' => false, 'volumetric' => nil, 'dispCallNumber' => 'Electronic resource', 'bib' => {
                  'resource' => '/catalog/bib', 'key' => '15513'
                }, 'itemList' => [{
                  'resource' => '/catalog/item',
                  'key' => '15513:10:1',
                  'fields' => {
                    'call' => {
                      'resource' => '/catalog/call', 'key' => '15513:10'
                    }, 'mediaDesk' => nil, 'itemType' => {
                      'resource' => '/policy/itemType', 'key' => 'ONLINE'
                    }, 'library' => {
                      'resource' => '/policy/library', 'key' => 'ONLINE'
                    }, 'shadowed' => false, 'homeLocation' => {
                      'resource' => '/policy/location', 'key' => 'ONLINE'
                    }, 'copyNumber' => 1, 'bib' => {
                      'resource' => '/catalog/bib', 'key' => '15513'
                    }, 'barcode' => '15513-10001', 'circulate' => true, 'currentLocation' => {
                      'resource' => '/policy/location', 'key' => 'ONLINE'
                    }
                  }
                }], 'classification' => {
                  'resource' => '/policy/classification', 'key' => 'ASIS'
                }
              }
            }], 'createDate' => '2001-04-12'
          }
        }
      }
    end
  end
end
