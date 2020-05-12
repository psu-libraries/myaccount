# frozen_string_literal: true

RENEWAL_RAW_JSON = {
  "finesAndFeesAssessed": nil,
  "circRecord": {
    "resource": "/circulation/circRecord",
    "key": "1682074:2:1:1",
    "fields": {
      "circulationRule": {
        "resource": "/policy/circulationRule",
        "key": "FASTSEMEST"
      },
      "recallDueDate": nil,
      "patron": {
        "resource": "/user/patron",
        "key": "333268"
      },
      "item": {
        "resource": "/catalog/item",
        "key": "1682074:2:1"
      },
      "piecesReturned": 0,
      "dueDate": "2020-05-15T23:59:00-04:00",
      "renewalCount": 35,
      "renewalDate": "2020-05-05T00:00:00-04:00",
      "estimatedOverdueAmount": {
        "currencyCode": "USD",
        "amount": "0.00"
      },
      "seenRenewalsRemaining": nil,
      "library": {
        "resource": "/policy/library",
        "key": "UP-PAMS"
      },
      "checkOutDate": "2008-07-26T15:30:00-04:00",
      "claimsReturnedDate": nil,
      "overdue": false,
      "unseenRenewalsRemaining": nil,
      "recalledDate": nil,
      "status": nil
    }
  }
}.freeze
