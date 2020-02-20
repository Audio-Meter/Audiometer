//
//  ChartView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/1/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class ChartView: UIView {
    var audiogram = Audiogram() {
        didSet {
            setNeedsDisplay()
        }
    }

    var frequency: Int? {
        didSet {
            setNeedsDisplay()
        }
    }

    var amplitude: Int? {
        didSet {
            setNeedsDisplay()
        }
    }

    func configure(grid: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: grid.leadingAnchor),
            topAnchor.constraint(equalTo: grid.topAnchor),
            widthAnchor.constraint(equalTo: grid.widthAnchor),
            heightAnchor.constraint(equalTo: grid.heightAnchor)
        ])
    }

    override func draw(_ rect: CGRect) {
        let scale = AudiogramScale(rect: bounds)
        drawSelected(scale: scale)
        drawAudiogram(scale: scale)
    }

    private func drawAudiogram(scale: AudiogramScale) {
        audiogram.items.forEach { conduction, frequencies in
            let color = conduction.color

            let path = UIBezierPath()
            path.lineWidth = 2
            if conduction.dashed {
                path.setLineDash([6, 6], count: 2, phase: 0)
            } else {
                path.setLineDash(nil, count: 0, phase: 0)
            }
            color.set()

            let pairs = frequencies.sorted(by: { $0.key < $1.key })
            pairs.enumerated().forEach { index, pair in
                let frequency = Metric.indexOf(freq: pair.0)
                let amplitude = Metric.indexOf(amp: pair.1.amplitude)
                let point = scale.point(frequency, amplitude)

                mark(conduction, pair.1.masked, pair.1.passed, at: point)
                if index == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.stroke()
        }
    }

    private func drawSelected(scale: AudiogramScale) {
        if let frequency = self.frequency, let amplitude = self.amplitude {
            let x = Metric.indexOf(freq: frequency)
            let y = Metric.indexOf(amp: amplitude)

            UIColor.green.set()
            let path = UIBezierPath()

            path.move(to: scale.point(0, y))
            path.addLine(to: scale.point(scale.maxX, y))

            path.move(to: scale.point(x, 0))
            path.addLine(to: scale.point(x, scale.maxY))

            path.stroke()
        }
    }

    private func mark(_ conduction: Conduction, _ masked: Bool, _ passed: Bool, at point: CGPoint) {
        let image = UIImage(named: conduction.symbol(masked: masked, pass: passed))!
        let origin = point.offsetBy(dx: -image.size.width / 2, dy: -image.size.height / 2)
        image.draw(at: origin)
    }
}
