//
//  ToneMaskingView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/26/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ToneMaskingView: UIView {
    let disposeBag = DisposeBag()
    let player = MaskingPlayer()

    let boxLabel = UILabel()

    let onOffLabel = UILabel()
    let onOffControl = UISwitch()

    let amplitudeLabel = UILabel()
    let amplitudeMinus = UIButton(type: .custom)
    let amplitudePlus = UIButton(type: .custom)
    let amplitudeValue = UILabel()
    let amplitudeDb = UILabel()

    let continuousLabel = UILabel()
    let continuousControl = UISwitch()

    let typeLabel = UILabel()
    let typeControl = UISegmentedControl()

    override func awakeFromNib() {
        super.awakeFromNib()
        styleViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = bounds.size
        boxLabel.pin.width(size.height).left(20 - size.height / 2).vCenter()

        let labelMargin: CGFloat = 5
        onOffLabel.pin.left(53).top(10)
        onOffControl.pin.below(of: onOffLabel, aligned: .left).marginTop(labelMargin)

        continuousControl.pin.left(to: onOffControl).bottom(10)
        continuousLabel.pin.above(of: continuousControl, aligned: .left).marginBottom(labelMargin)

        typeControl.pin.right(20).bottom(to: continuousControl).width(125)
        typeLabel.pin.left(to: typeControl).top(to: continuousLabel)

        amplitudeLabel.pin.left(to: typeControl).top(to: onOffLabel)
        amplitudeMinus.pin.height(of: onOffControl).aspectRatio(1).left(to: amplitudeLabel).top(to: onOffControl)
        amplitudePlus.pin.size(of: amplitudeMinus).top(to: amplitudeMinus).right(to: typeControl)
        amplitudeValue.pin.after(of: amplitudeMinus, aligned: .top).right(to: amplitudePlus.edge.left).marginTop(-2)
        amplitudeDb.pin.after(of: amplitudeMinus, aligned: .bottom).right(to: amplitudePlus.edge.left).marginBottom(-3)
    }

    func styleViews() {
        Styles.box.apply(to: self)
        Styles.label(font: fontStyle.size(15).weight(600), color: .darkerGray)
            .align(.center)
            .vertical(value: true)
            .apply(text: "MASKING", to: boxLabel.from(self))

        labelStyle.apply(text: "On/Off", to: onOffLabel.from(self))
        addSubview(onOffControl)

        labelStyle.apply(text: "Continuous", to: continuousLabel.from(self))
        addSubview(continuousControl)

        styleAmplitude()

        labelStyle.apply(text: "Type", to: typeLabel.from(self))
        Styles.segmentedControl.apply(titles: "WN", "NBN", to: typeControl.from(self))
    }

    func styleAmplitude() {
        let buttonStyle = Styles.button.solid().textFont(fontStyle.size(18))
        labelStyle.apply(text: "Amplitude", to: amplitudeLabel.from(self))
            
        buttonStyle.apply(title: "-",buttonImage:UIImage(named: "")!, to: amplitudeMinus.from(self))
        
        buttonStyle.apply(title: "+",buttonImage:UIImage(named: "")!, to: amplitudePlus.from(self))

        labelStyle.font(fontStyle.size(17)).align(.center).apply(text: "40", to: amplitudeValue.from(self))
        Styles.label(font: fontStyle.size(14), color: .darkGray).align(.center).apply(text: "dB HL", to: amplitudeDb.from(self))
    }

    var labelStyle: LabelStyle {
        return Styles.label(font: fontStyle.size(15), color: .lightBlack)
    }

    var fontStyle: FontStyle {
        return Styles.font.normal
    }
}

extension ToneMaskingView {
    func bind(model: MaskingIdea) {
        onOffControl.rx.value <||> model.isEnabled ||> disposeBag
        continuousControl.rx.value ||> model.isContinuos ||> disposeBag

        model.amplitudeText ||> amplitudeValue.rx.text ||> disposeBag
        amplitudeMinus.rx.tap ||> model.minus ||> model.updateAmplitude ||> disposeBag
        amplitudePlus.rx.tap ||> model.plus ||> model.updateAmplitude ||> disposeBag
        model.config ||> player.rx.config ||> disposeBag
        typeControl.rx.value <||> model.type ||> disposeBag
    }
}
