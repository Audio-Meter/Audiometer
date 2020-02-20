//
//  AudiogramScale.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/31/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct AudiogramScale {
    let maxX: CGFloat = CGFloat(Metric.mainFreqs.count - 1)
    let maxY: CGFloat = CGFloat(Metric.mainAmps.count - 1)
    let lineWidth: CGFloat = 2

    let rect: CGRect
    let deltaX: CGFloat
    let deltaY: CGFloat

    init(rect: CGRect) {
        self.rect = rect
        deltaX = (rect.size.width - lineWidth) / maxX
        deltaY = (rect.size.height - lineWidth) / maxY
    }

    func x(_ value: CGFloat) -> CGFloat {
        return rect.origin.x + lineWidth / 2 + value * deltaX
    }

    func y(_ value: CGFloat) -> CGFloat {
        return rect.origin.y + lineWidth / 2 + value * deltaY
    }

    func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x(x), y: self.y(y))
    }
}
