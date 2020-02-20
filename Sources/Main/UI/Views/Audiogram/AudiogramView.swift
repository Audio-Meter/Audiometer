//
//  AudiogramView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/31/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class AudiogramView: UIView {
    let lightColor = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1)
    let darkColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)

    @IBOutlet var grid: AudiogramGridView!
    let chart = ChartView()

    init() {
        grid = AudiogramGridView()
        grid.backgroundColor = .clear
        super.init(frame: .zero)

        backgroundColor = .clear
        flex.width(546).height(450)
        flex.addItem(grid).marginLeft(55).marginTop(50).width(400).height(360)

        awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        let lab = AmpLabel()
        addSubview(lab)
        lab.configure(grid: grid)

        addSubview(chart)
        chart.configure(grid: grid)
    }

    lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        self.addGestureRecognizer(recognizer)
        return recognizer
    }()

    func valueAt(point: CGPoint) -> Audiogram.Entry? {
        let scale = self.scale
        return chart.audiogram.flatten().map { item->(Audiogram.Entry, CGFloat) in
            let center = scale.point(
                Metric.indexOf(freq: item.0.frequency),
                Metric.indexOf(amp: item.1.amplitude)
            )
            return (item, center.distance(to: point))
        }.sorted(by: { $0.1 < $1.1 }).filter { $0.1 < scale.deltaY }.first.flatMap { $0.0 }
    }

    var scale: AudiogramScale {
        return AudiogramScale(rect: grid.frame)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let scale = self.scale

        Metric.mainFreqs.enumerated().dropFirst().forEach { index, freq in
            let x = scale.x(CGFloat(index))
            label(text: String(freq), size: 14, align: .center, x: x, y: scale.rect.minY - 24, color: lightColor)
        }
        Metric.auxFreqs.forEach { freq in
            let index = Metric.indexOf(freq: freq)
            let x = scale.x(CGFloat(index))
            label(text: String(freq), size: 14, align: .center, x: x, y: scale.rect.minY - 39, color: lightColor)
        }
        Metric.percentFreqs.enumerated().forEach { index, percent in
            let x = scale.x(CGFloat(index + 1))
            label(text: "\(percent)%", size: 14, align: .center, x: x, y: scale.y(scale.maxY + 0.1), color: lightColor)
        }

        Metric.mainAmps.enumerated().forEach { index, amp in
            let y = scale.y(CGFloat(index)) - 17
            label(text: String(amp), size: 14, align: .right, x: scale.rect.minX - 110, y: y, color: lightColor)
            label(text: String(amp), size: 14, align: .right, x: scale.rect.maxX + 5, y: y, width: 30, color: lightColor)
        }

        label(text: "Frequency, Hz", size: 14, align: .left, x: scale.rect.minX, y: scale.rect.minY - 44, color: darkColor)
        
        label(text: "Speech", size: 12, align: .left, x: scale.rect.minX + 20, y: scale.rect.midY - 35, color: grid.darkColor)
        label(text: "Level", size: 12, align: .left, x: scale.rect.minX + 20, y: scale.rect.midY - 12, color: grid.darkColor)
    }
}

class AmpLabel: UIView {
    let lightColor = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1)

    func configure(grid: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 50),
            heightAnchor.constraint(equalToConstant: 20),
            centerYAnchor.constraint(equalTo: grid.centerYAnchor),
            leftAnchor.constraint(equalTo: grid.leftAnchor, constant: -70)
        ])
        transform = CGAffineTransform(rotationAngle: -.pi / 2);
    }

    override func draw(_ rect: CGRect) {
        label(text: "dB HL", size: 14, align: .center, x: bounds.midX, y: 0, color: lightColor)
    }
}

extension Reactive where Base: AudiogramView {
    var value: Binder<Audiogram> {
        return Binder(base) { view, value in
            view.chart.audiogram = value
        }
    }

    var tap: Observable<Audiogram.Entry> {
        return base.tapRecognizer.rx.event.map {
            return self.base.valueAt(point: $0.location(in: self.base))
        }.filterNil()
    }

    var frequency: Binder<Int> {
        return Binder(base) { view, value in
            view.chart.frequency = value
        }
    }

    var amplitude: Binder<Int> {
        return Binder(base) { view, value in
            view.chart.amplitude = value
        }
    }
}
