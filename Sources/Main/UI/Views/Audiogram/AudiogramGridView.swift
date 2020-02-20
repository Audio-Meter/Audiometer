//
//  AudiogramGridView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/31/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class AudiogramGridView: UIView {
    let lightColor = #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1)
    let darkColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var scale: AudiogramScale {
        return AudiogramScale(rect: bounds)
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let scale = self.scale
        lightColor.set()

        path.lineWidth = 1
        stride(from: 0, to: scale.maxX + 1, by: 1).forEach { x in
            path.move(to: scale.point(x, 0))
            path.addLine(to: scale.point(x, scale.maxY))
        }
        stride(from: 0, to: scale.maxY + 1, by: 1).filter { $0 != 6 }.forEach { y in
            path.move(to: scale.point(0, y))
            path.addLine(to: scale.point(scale.maxX, y))
        }
        path.stroke()

        path.removeAllPoints()
        path.setLineDash([6, 6], count: 2, phase: 0)

        Metric.auxFreqs.map { Metric.indexOf(freq: $0) }.forEach { x in
            path.move(to: scale.point(x, 0))
            path.addLine(to: scale.point(x, scale.maxY))
        }
        path.stroke()

        darkColor.set()
        path.removeAllPoints()
        path.setLineDash(nil, count: 0, phase: 0)
        path.move(to: scale.point(0, 6))
        path.addLine(to: scale.point(scale.maxX, 6))
        path.stroke()
    }
}
