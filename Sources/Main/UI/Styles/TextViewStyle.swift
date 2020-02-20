//
//  TextViewStyle.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/3/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct TextViewStyle {
    static func apply(to view: UITextView) {
        view.textColor = ColorStyle.lightBlack.apply()
        view.font = FontStyle.normal.size(16).apply()

        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
    }
}
