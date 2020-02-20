//
//  TalkIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/28/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class TalkIdea {
    let isStarted = Variable(false)
    let volume = Variable(TalkVolume.medium)

    func toggle() -> Bool {
        return !isStarted.value
    }

    var gain: Observable<Double> {
        return Observable.combineLatest(isStarted.asObservable(), volume.asObservable()) {
            guard $0 else {
                return 0
            }
            return $1.value
        }
    }

    var isPushed: Observable<Bool> {
        return isStarted.asObservable()
    }

    var pushTitle: Observable<String> {
        return isPushed.map { $0 ? "Stop" : "Push to talk" }
    }
}
