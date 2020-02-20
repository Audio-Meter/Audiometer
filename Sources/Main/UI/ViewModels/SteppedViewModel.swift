//
//  SteppedViewModel.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxCocoa

enum SteppedType: Int {
    case slider, button
}

class SteppedViewModel {
    let type: Variable<SteppedType>
    let possibleValues: [Int]
    let index: Variable<Int>

    init(type: SteppedType = .slider, possibleValues: [Int], value: Int) {
        self.type = Variable(.slider)
        self.possibleValues = possibleValues
        self.index = Variable(possibleValues.index(of: value) ?? 0)
    }

    var values: Observable<Int> {
        return index.asObservable().map { self.possibleValues[$0] }
    }

    var sliderSelected: Observable<Bool> {
        return type.asObservable().map { $0 == .slider }
    }

    var valueLabel: Observable<String> {
        return values.map { String($0) }
    }

    func previous() -> Int {
        if index.value > 0 {
            return index.value - 1
        }
        return 0
    }

    func next() -> Int {
        if index.value < possibleValues.count - 1 {
            return index.value + 1
        }
        return possibleValues.count - 1
    }
}
