//
//  TonePlayerIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class TonePlayerIdea {
    let test: TestIdea

    let typeIndex = Variable(0)
    let warbleModulation = Variable(1)
    let warbleFrequency = Variable(1)
    let pulseDuration = Variable(0)

    init(test: TestIdea) {
        self.test = test
    }

    var types: Observable<ToneType> {
        return typeIndex.asObservable().map { index->Observable<ToneType> in
            switch index {
            case 0: return .just(.steady)
            case 1:
                return Observable.combineLatest(self.warbleModulation.asObservable(), self.warbleFrequency.asObservable()) {
                    let values: [Double] = [5, 10, 20]
                    return .warble(modulation: values[$0], frequency: values[$1])
                }
            case 2:
                return self.pulseDuration.asObservable().map {
                    let hz: [Double] = [2.5, 1, 0.5]
                    return .pulsed(frequency: hz[$0])
                }
            default: fatalError()
            }
        }.switchLatest()
    }

    var isWarble: Observable<Bool> {
        return typeIndex.asObservable().map { $0 == 1 }
    }

    var isPulse: Observable<Bool> {
        return typeIndex.asObservable().map { $0 == 2 }
    }

    var settings: Observable<ToneSettings> {
        return Observable.combineLatest(
            test.calibration(type: .tone),
            test.pan,
            types,
            test.frequency,
            test.amplitude
        ) {
            return ToneSettings(
                calibration: $0,
                pan: $1,
                toneType: $2,
                frequency: $3,
                dBHL: $4
            )
        }
    }
}
