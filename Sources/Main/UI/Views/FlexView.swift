//
//  FlexView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/29/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

class FlexView: UIView {
    let flexContainer = UIView()

    init() {
        super.init(frame: .zero)
        addSubview(flexContainer)

        layout(flex: flexContainer.flex)
        styleViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func styleViews() {}

    override func layoutSubviews() {
        super.layoutSubviews()
        flexContainer.pin.all().margin(pin.safeArea)
        flexContainer.flex.layout()
    }

    func layout(closure: (Flex)->Void) {
        closure(flexContainer.flex)
    }

    func layout(flex: Flex) {
    }
}
