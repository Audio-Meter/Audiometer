//
//  UISegmentedControl+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    var titles: [String] {
        get {
            return (0..<numberOfSegments).map { titleForSegment(at: $0)! }
        }
        set {
            removeAllSegments()
            newValue.enumerated().forEach { index, title in
                insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
}
