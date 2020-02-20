//
//  TalkPlayer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/20/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit
import RxSwift
import RxCocoa

enum TalkVolume: Int {
    case low, medium, high
    
    var value: Double {
        switch self {
        case .low: return 0.3
        case .medium: return 0.5
        case .high: return 0.7
        }
    }
}

class TalkPlayer: ReactiveCompatible, AudioPlayer {
    let microphone : AKMicrophone //= AKMicrophone()
    let booster: AKBooster

    init() {
        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
        microphone = AKMicrophone()!
        booster = AKBooster(microphone, gain: 0)
        booster.gain = 0
    }

    var node: AKNode {
        return booster
    }
}

extension Reactive where Base: TalkPlayer {
    var gain: Binder<Double> {
        return Binder(base) { view, value in
            view.booster.gain = value
        }
    }
}
