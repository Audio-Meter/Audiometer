//
//  MaskingIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/28/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class MaskingIdea {
    let test: TestIdea

    let isEnabled = Variable(false)
    let isContinuos = Variable(false)
    let amplitude = Variable(40)
    let type = Variable(MaskingType.wn)
    let typeIndexPath = Variable(IndexPath(row: 4, section: 0)) 

    init(test: TestIdea) {
        self.test = test
    }
    
    var typeVariable: Observable<Void> {
        return typeIndexPath.asObservable().map {
            switch $0.row {
                case 0: self.type.value = MaskingType.wn
                case 1: self.type.value = MaskingType.nbn
                case 2: self.type.value = MaskingType.pn
                case 3: self.type.value = MaskingType.sn
                default: break
            }
        }
    }

    var isPlayed: Observable<Bool> {
        return Observable.combineLatest(test.isPlayed, isEnabled.asObservable(), isContinuos.asObservable()) {
            return $1 && ($0 || $2)
        }.distinctUntilChanged()
    }

    var calibration: Observable<Calibration> {
        return type.asObservable().map {
            self.test.calibration(type: .masking($0))
        }.switchLatest()
    }

    var config: Observable<MaskingConfig> {
        return Observable.combineLatest(isPlayed, amplitude.asObservable(), calibration, test.frequency, test.pan, type.asObservable()) {
            MaskingConfig(isPlayed: $0, dBHL: $1, calibration: $2, baseFrequency: $3, pan: $4, type: $5)
        }
    }

    var amplitudeText: Observable<String> {
        return amplitude.asObservable().map { String($0) }
    }
    
    func minus() -> Int {
        return -1
    }
    
    func plus() -> Int {
        return +1
    }
    
    func updateAmplitude(_ signs: Observable<Int>) -> Disposable {
        return signs.scan(to: amplitude) { value, sign in
            return value + 10 * sign
        }
    }
}
