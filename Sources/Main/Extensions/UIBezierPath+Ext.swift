//
//  UIBezierPath+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

extension UIBezierPath {
    convenience init(circleCenter point: CGPoint, radius: CGFloat) {
        self.init(ovalIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
    }
}
