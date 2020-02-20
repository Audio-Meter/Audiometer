//
//  TestIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

struct TestIdea {
    let app: App

    let isPlayed: Observable<Bool>
    let frequency: Observable<Int>
    let amplitude: Observable<Int>

    let pan: Observable<Double>
    let transducer: Observable<Transducer>

    var playDidToggled: Observable<Bool> {
        return isPlayed.distinctUntilChanged().skip(1)
    }

    var playDidTapped: Observable<Void> {
        return playDidToggled.filter { $0 == true }.void()
    }

    var pauseDidTapped: Observable<Void> {
        return playDidToggled.filter { $0 == false }.void()
    }

    func calibration(type: CalibrationType) -> Observable<Calibration> {
        return Observable.combineLatest(transducer, pan) {
            self.app.calibrations.load(transducer: $0, type: type, pan: $1)
        }
    }
}
