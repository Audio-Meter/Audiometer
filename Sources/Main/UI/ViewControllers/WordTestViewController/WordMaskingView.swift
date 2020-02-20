//
//  WordMaskingView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/28/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WordMaskingView: UIView {
    let disposeBag = DisposeBag()

    @IBOutlet var isEnabled: UISwitch!
    @IBOutlet var amplitude: UILabel!
    @IBOutlet var minus: UIButton!
    @IBOutlet var plus: UIButton!
    @IBOutlet var type: UISegmentedControl!

    let player = MaskingPlayer()
}

extension WordMaskingView {
    func bind(model: MaskingIdea) {
        isEnabled.rx.value <||> model.isEnabled ||> disposeBag
        model.amplitudeText ||> amplitude.rx.text ||> disposeBag
        minus.rx.tap ||> model.minus ||> model.updateAmplitude ||> disposeBag
        plus.rx.tap ||> model.plus ||> model.updateAmplitude ||> disposeBag
        model.config ||> player.rx.config ||> disposeBag
        type.rx.value <||> model.type ||> disposeBag
    }
}
