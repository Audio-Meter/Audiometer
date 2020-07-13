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
    let typeIndexPath = Variable(IndexPath(row: 0, section: 0))
    
    let warbleModulation = Variable(1)
    let warbleModulationIndexPath = Variable(IndexPath(row: 0, section: 0))
    
    let warbleFrequency = Variable(1)
    let warbleFrequencyIndexPath = Variable(IndexPath(row: 0, section: 0))
    
    let pulseDuration = Variable(0)
    let pulseDurationIndexPath = Variable(IndexPath(row: 0, section: 0))

     let conductionIdea = ConductionIdea()
    
    init(test: TestIdea) {
        self.test = test
    }

    var types: Observable<ToneType> {
        return typeIndexPath.asObservable().map { index->Observable<ToneType> in
            switch index.row {
            case 0:
                return .just(.steady)
            case 1:
                return Observable.combineLatest(self.warbleModulationIndexPath.asObservable(), self.warbleFrequencyIndexPath.asObservable()) {
                    let values: [Double] = [5, 10, 20]
                    return .warble(modulation: values[$0.row], frequency: values[$1.row])
                }
            case 2:
                return self.pulseDurationIndexPath.asObservable().map {
                    let hz: [Double] = [2.5, 1, 0.5]
                    return .pulsed(frequency: hz[$0.row])
                }
            default: fatalError()
            }
        }.switchLatest()
    }

    var isWarble: Observable<Bool> {
        return typeIndexPath.asObservable().map { $0.row == 1 }
    }

    var isPulse: Observable<Bool> {
        return typeIndexPath.asObservable().map { $0.row == 2 }
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
