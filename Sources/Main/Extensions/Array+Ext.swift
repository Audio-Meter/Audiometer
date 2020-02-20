//
//  Array+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/15/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: Equatable {
    func uniq() -> [Element] {
        var result: [Element] = []
        for element in self {
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }
}

extension Array {
    func group<E: Equatable>(by key: (Element)->E) -> [[Element]] {
        return map(key).uniq().map { k in
            filter { key($0) == k }
        }
    }
}

extension Array where Element == CGFloat {
    func sum() -> CGFloat {
        return reduce(0, +)
    }
}
