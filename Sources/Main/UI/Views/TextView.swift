//
//  TextView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/16/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class TextView: UITextView {
    override func awakeFromNib() {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
    }
}
