//
//  LabelStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct LabelStyle {
    var font: FontStyle
    var color: ColorStyle
    var alignment: NSTextAlignment
    var vertical: Bool

    static let h2 = Styles.label(
        font: FontStyle.normal.size(16).weight(.bold), color: .darkGray2
    )

    static let h5 = Styles.label(
        font: FontStyle.normal.size(16).weight(.medium), color: .darkGray2
    )

    func apply(text: String) -> UILabel {
        let label = UILabel()
        apply(text: text, to: label)
        return label
    }

    func apply(text: String, to label: UILabel) {
        label.font = font.apply()
        label.textColor = color.apply()
        label.textAlignment = alignment
        label.text = text

        if vertical {
            label.transform = .init(rotationAngle: -CGFloat.pi / 2)
        }
    }

    func font(_ value: FontStyle) -> LabelStyle {
        var style = self
        style.font = value
        return style
    }

    func align(_ value: NSTextAlignment) -> LabelStyle {
        var style = self
        style.alignment = value
        return style
    }

    func vertical(value: Bool) -> LabelStyle {
        var style = self
        style.vertical = value
        return style
    }
}
