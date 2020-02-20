//
//  PinLayout+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import PinLayout

extension PinLayout {
    @discardableResult
    func topLeft(to view: UIView) -> PinLayout {
        return topLeft(to: view.anchor.topLeft)
    }

    @discardableResult
    func left(to view: UIView) -> PinLayout {
        return left(to: view.edge.left)
    }

    @discardableResult
    func right(to view: UIView) -> PinLayout {
        return right(to: view.edge.right)
    }

    @discardableResult
    func top(to view: UIView) -> PinLayout {
        return top(to: view.edge.top)
    }

    @discardableResult
    func bottom(to view: UIView) -> PinLayout {
        return bottom(to: view.edge.bottom)
    }
}
