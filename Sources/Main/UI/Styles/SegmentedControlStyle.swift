//
//  SegmentedControlStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct SegmentedControlStyle {
    static func apply(titles: String..., to view: UISegmentedControl) {
        apply(titles: titles, to: view)
    }

    static func apply(titles: [String], to control: UISegmentedControl) {
        control.translatesAutoresizingMaskIntoConstraints = false
        control.titles = titles
        control.tintColor = ColorStyle.blue.apply()
        control.setTitleTextAttributes(
            [NSAttributedStringKey.font: FontStyle.normal.apply()],
            for: .normal
        )
    }
}
