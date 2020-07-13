//
//  Styles.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

enum Styles {
    static let color = ColorStyle.self
    static let font = FontStyle.self
    static let views = BoxStyle.self
    static let box = BoxStyle.box
    static let button = ButtonStyle.self
    static let segmentedControl = SegmentedControlStyle.self
    static let labels = LabelStyle.self
    static let textView = TextViewStyle.self
    static let lines = LineStyle.self

    static func label(font: FontStyle = .normal, color: ColorStyle = .black) -> LabelStyle {
        return LabelStyle(font: font, color: color, alignment: .left, vertical: false)
    }
    
}
