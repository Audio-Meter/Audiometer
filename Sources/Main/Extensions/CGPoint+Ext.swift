//
//  CGPoint+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }

    func distance(to point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
}
