//
//  BoxStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct BoxStyle {
    var backgroundColor: ColorStyle
    var borderColor: ColorStyle?
    var cornerRadius: CGFloat?

    @discardableResult
    func apply(to view: UIView) -> UIView {
        view.backgroundColor = backgroundColor.apply()
        if let borderColor = borderColor {
            view.layer.borderColor = borderColor.apply().cgColor
            view.layer.borderWidth = 1
        }
        if let cornerRadius = cornerRadius {
            view.layer.cornerRadius = cornerRadius
        }
        return view
    }

    static var box: BoxStyle {
        return BoxStyle(backgroundColor: .lighterGray, borderColor: nil, cornerRadius: 5)
    }

    static var root: BoxStyle {
        return BoxStyle(backgroundColor: .white, borderColor: nil, cornerRadius: nil)
    }

    static let bordered = cells

    static var cells: BoxStyle {
        return BoxStyle(backgroundColor: .clear, borderColor: .stupidGray, cornerRadius: nil)
    }
}
