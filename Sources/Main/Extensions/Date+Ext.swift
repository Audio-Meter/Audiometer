//
//  Date+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/7/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

extension Date {
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }

    static func parse(_ formatted: String) -> Date {
        return formatter.date(from: formatted)!
    }

    func format() -> String {
        return Date.formatter.string(from: self)
    }
}
