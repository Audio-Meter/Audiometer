//
//  LineStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/3/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import FlexLayout

struct LineStyle {
    var color: ColorStyle
    var size: CGFloat

    static var text = LineStyle(color: .black, size: 0.5)

    func hr() -> UIView {
        let view = UIView()
        view.backgroundColor = color.apply()
        view.flex.height(size).width(100%)
        return view
    }
}
