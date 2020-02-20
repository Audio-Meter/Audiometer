//
//  ToneSettingsView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/26/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class ToneSettingsView: UIView {
    let disposeBag = DisposeBag()

    let boxLabel = UILabel()
    let channelLabel = UILabel()
    let channelControl = ChannelsView()

    let conductionLabel = UILabel()
    let conductionControl = UISegmentedControl()

    let typeLabel = UILabel()
    let typeControl = UISegmentedControl()

    let pulseLabel = UILabel()
    let pulseControl = UISegmentedControl()

    let frequencyLabel = UILabel()
    let frequencyControl = UISegmentedControl()

    let modulationLabel = UILabel()
    let modulationControl = UISegmentedControl()

    let player = TonePlayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        styleViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = bounds.size
        boxLabel.pin.width(size.height).left(20 - size.height / 2).vCenter()

        let labelMargin: CGFloat = 5
        channelLabel.pin.left(53).top(10)
        channelControl.pin.below(of: channelLabel, aligned: .left).marginTop(labelMargin).width(124).height(of: conductionControl)

        conductionControl.pin.after(of: channelControl, aligned: .top).marginLeft(20).width(300)
        conductionLabel.pin.top(to: channelLabel).left(to: conductionControl)

        typeControl.pin.bottom(10).left(to: channelControl).width(220)
        typeLabel.pin.above(of: typeControl, aligned: .left).marginBottom(labelMargin)

        pulseControl.pin.after(of: typeControl, aligned: .top).marginLeft(20).width(200)
        pulseLabel.pin.top(to: typeLabel).left(to: pulseControl)

        frequencyLabel.pin.topLeft(to: pulseLabel)
        frequencyControl.pin.topLeft(to: pulseControl).width(177)

        modulationControl.pin.after(of: frequencyControl, aligned: .top).marginLeft(20).width(157)
        modulationLabel.pin.top(to: frequencyLabel).left(to: modulationControl)
    }

    func styleViews() {
        Styles.box.apply(to: self)
        Styles.label(font: fontStyle.size(15).weight(600), color: .darkerGray)
            .align(.center)
            .vertical(value: true)
            .apply(text: "TONE", to: boxLabel.from(self))

        labelStyle.apply(text: "Ear", to: channelLabel.from(self))
        addSubview(channelControl)

        labelStyle.apply(text: "Conduction", to: conductionLabel.from(self))
        Styles.segmentedControl.apply(titles: "Air", "Bone", "Soundfield", to: conductionControl.from(self))

        labelStyle.apply(text: "Type", to: typeLabel.from(self))
        Styles.segmentedControl.apply(titles: "Steady", "Warble", "Pulsed", to: typeControl.from(self))

        labelStyle.apply(text: "Pulse duration", to: pulseLabel.from(self))
        Styles.segmentedControl.apply(titles: "200ms", "500ms", "1s", to: pulseControl.from(self))

        labelStyle.apply(text: "Warble frequency", to: frequencyLabel.from(self))
        Styles.segmentedControl.apply(titles: "5Hz", "10Hz", "20Hz", to: frequencyControl.from(self))

        labelStyle.apply(text: "Modulation", to: modulationLabel.from(self))
        Styles.segmentedControl.apply(titles: "5%", "10%", "20%", to: modulationControl.from(self))
    }

    var labelStyle: LabelStyle {
        return Styles.label(font: fontStyle.size(15), color: .lightBlack)
    }

    var fontStyle: FontStyle {
        return Styles.font.normal
    }
}

extension ToneSettingsView {
    func bind(model: TonePlayerIdea) {
        model.settings ||> player.settings ||> disposeBag
        model.test.playDidTapped ||> player.play ||> disposeBag
        model.test.pauseDidTapped ||> player.stop ||> disposeBag

        typeControl.rx.value <||> model.typeIndex ||> disposeBag

        model.isWarble ||> frequencyLabel.rx.isShown ||> disposeBag
        model.isWarble ||> frequencyControl.rx.isShown ||> disposeBag
        frequencyControl.rx.value <||> model.warbleFrequency ||> disposeBag

        model.isWarble ||> modulationLabel.rx.isShown ||> disposeBag
        model.isWarble ||> modulationControl.rx.isShown ||> disposeBag
        modulationControl.rx.value <||> model.warbleModulation ||> disposeBag

        pulseControl.rx.value <||> model.pulseDuration ||> disposeBag
        model.isPulse ||> pulseLabel.rx.isShown ||> disposeBag
        model.isPulse ||> pulseControl.rx.isShown ||> disposeBag
    }
}

extension ToneSettingsView {
    func bind(model: ConductionIdea) {
        channelControl.bind(model: model)
        conductionControl.rx.value <||> model.conductionIndex ||> disposeBag
    }
}
