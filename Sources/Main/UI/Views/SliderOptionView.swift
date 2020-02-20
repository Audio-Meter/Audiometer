//
//  SliderOptionView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/18/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import VerticalSteppedSlider
import RxSwift
import RxCocoa

class SliderOptionView: UIView {
    let minColor = #colorLiteral(red: 0.3098039216, green: 0.8235294118, blue: 0.3843137255, alpha: 1)
    let maxColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
    let markColor = #colorLiteral(red: 0.6980392157, green: 0.6980392157, blue: 0.6980392157, alpha: 1)
    let markFont = UIFont.systemFont(ofSize: 14, weight: .regular)

    @IBOutlet var slider: VSSlider!

    var marks: [Int] = [] {
        didSet {
            slider.maximumValue = Float(marks.count - 1)
            DispatchQueue.main.async {
                self.marks.enumerated().forEach {
                    self.addMark(index: $0.0, value: $0.1)
                }
                self.setSelected(Int(self.slider.roundedValue))
            }
        }
    }

    var markLabels: [UILabel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        configureSlider()
    }
    
    func setSelected(_ selectedIndex: Int) {
        markLabels.enumerated().forEach { labelIndex, label in
            let selected = labelIndex == selectedIndex
            label.textColor = selected ? minColor : markColor
        }
    }

    private func configureSlider() {
        slider.vertical = true
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.increment = 1
        slider.trackWidth = 8
        slider.markWidth = 0
        slider.maximumTrackTintColor = maxColor
        slider.minimumTrackTintColor = minColor
        slider.backgroundColor = .clear
        slider.isContinuous = true
    }
    
    private func addMark(index: Int, value: Int) {
        let label = UILabel()
        label.font = markFont
        label.textColor = maxColor
        label.text = String(value)
        addSubview(label)
        markLabels.append(label)

        let midY = thumbRect(value: Float(index)).midY
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: (superview?.leadingAnchor)!, constant: markOffset(index + Int(slider.frame.width / 2))),
            label.centerYAnchor.constraint(equalTo: slider.topAnchor, constant: midY)
        ])
    }

    private func thumbRect(value: Float) -> CGRect {
        let internalSlider = self.internalSlider
        let sliderBounds = internalSlider.bounds
        let trackBounds = internalSlider.trackRect(forBounds: sliderBounds)
        let thumbRect = internalSlider.thumbRect(forBounds: sliderBounds, trackRect: trackBounds, value: value)
        return self.convert(thumbRect, from: internalSlider)
    }

    private func markOffset(_ index: Int) -> CGFloat {
        if marks.count < 15 {
            return 10
        } else {
            return (index % 2 == 0) ? 50 : 10
        }
    }

    private var internalSlider: UISlider {
        return slider.subviews[0] as! UISlider
    }
}

extension Reactive where Base: SliderOptionView {
    var selectedIndex: Binder<Int> {
        return Binder(base) { view, index in
            view.setSelected(index)
        }
    }
}

extension Reactive where Base: VSSlider {
    var value: ControlProperty<Int> {
        return base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { Int($0.roundedValue) },
            setter: { $0.value = Float($1) }
        )
    }
}
