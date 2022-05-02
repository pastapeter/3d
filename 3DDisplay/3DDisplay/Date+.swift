//
//  Date+.swift
//  3DDisplay
//
//  Created by Jung peter on 2022/05/01.
//

import Foundation

extension Date {
  func toString() -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy.MM.dd HH:mm"
    return dateformatter.string(from: self)
  }
}
