//
//  TonePlayer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/12/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit
import RxSwift
import RxCocoa

struct ToneSettings {
    let calibration: Calibration
    let pan: Double
    let toneType: ToneType
    let frequency: Int
    let dBHL: Int

    func fs(dBHL: Int) -> Double {
        return calibration.fs(frequency: frequency, dBHL: dBHL)
    }
}

class TonePlayer: ReactiveCompatible, AudioPlayer {
    let played = PublishRelay<Bool>()
    let settings = PublishRelay<ToneSettings>()

    var node: AKNode {
        let builder = ToneBuilder(settings: settings.asObservable(), played: played.startWith(false), stopped: rx.deallocated)
        return builder.output
    }

    func play() {
        played.accept(true)
    }

    func stop() {
        played.accept(false)
    }
}
