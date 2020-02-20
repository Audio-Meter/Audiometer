//
//  WordSettingsView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class WordSettingsView: UIView {
    let disposeBag = DisposeBag()

    @IBOutlet var channel: ChannelsView!
    @IBOutlet var conduction: UISegmentedControl!
    @IBOutlet var type: UISegmentedControl!
}

extension WordSettingsView {
    func bind(model: ConductionIdea) {
        channel.bind(model: model)
        conduction.rx.value <||> model.conductionIndex ||> disposeBag
    }

    func bind(model: WordPlayerIdea) {
        type.rx.value <||> model.type ||> disposeBag
    }
}
