//
//  WordTestResultViewModel.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/20/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class WordTestResultViewModel {
    let patientId: String
    var comment: String?
    lazy var values: Variable<WordTestResult> = {
        return Variable(WordTestResult.test(patientId: self.patientId, comment: self.comment!))
    }()

    var srt_l: Observable<String> {
        return format { $0.srt[.air(.left)] }
    }

    var srt_r: Observable<String> {
        return format { $0.srt[.air(.right)] }
    }

    var srt_sf: Observable<String> {
        return format { $0.srt[.soundfield] }
    }

    var sd_l: Observable<String> {
        return format { $0.sd[.air(.left)] }
    }

    var sd_r: Observable<String> {
        return format { $0.sd[.air(.right)] }
    }

    var sd_sf: Observable<String> {
        return format { $0.sd[.soundfield] }
    }

    var mcl_l: Observable<String> {
        return format { $0.comfortLevels[.mcl]?[.air(.left)] }
    }

    var mcl_r: Observable<String> {
        return format { $0.comfortLevels[.mcl]?[.air(.right)] }
    }

    var mcl_sf: Observable<String> {
        return format { $0.comfortLevels[.mcl]?[.soundfield] }
    }

    var ucl_l: Observable<String> {
        return format { $0.comfortLevels[.ucl]?[.air(.left)] }
    }

    var ucl_r: Observable<String> {
        return format { $0.comfortLevels[.ucl]?[.air(.right)] }
    }

    var ucl_sf: Observable<String> {
        return format { $0.comfortLevels[.ucl]?[.soundfield] }
    }

    private func format(calc: @escaping (WordTestResult)->Int?) -> Observable<String> {
        return values.asObservable().map { value in
            calc(value).flatMap { String($0) } ?? "〜"
        }
    }
    
    init(patientId: String, comment: String) {
        self.comment = comment
        self.patientId = patientId
    }
}
