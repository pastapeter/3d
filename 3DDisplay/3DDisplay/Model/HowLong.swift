//
//  HowLong.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/04/13.
//

import Foundation

enum HowLong: CaseIterable, CustomStringConvertible {
  var description: String {
    switch self {
    case .lessthan1m:
      return "less than 1 month"
    case .between1mAnd6m:
      return "more than 1 month to less 6 months"
    case .between6mAnd1y:
      return "more than 6 months to less than 1 year"
    case .between1yAnd3y:
      return "more than 1 year to less than 3 years"
    case .between3yAnd5y:
      return "more than 3 years to less than 5 years"
    case .morethan5y:
      return "more than 5 years"
    }
  }
  
  case lessthan1m
  case between1mAnd6m
  case between6mAnd1y
  case between1yAnd3y
  case between3yAnd5y
  case morethan5y
}
