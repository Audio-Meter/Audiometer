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

enum FrequencySteppedType: Int{
    case button, slider
}
enum AmplitudeSteppedType: Int{
    case slider, button
}


class SteppedViewModel {
    let typeAmplitude: Variable<AmplitudeSteppedType>?
    let typeFrequency: Variable<FrequencySteppedType>?
    let possibleValues: [Int]
    let index: Variable<Int>

    init(type: SteppedType = .slider, possibleValues: [Int], value: Int) {
        if type == .slider{
            self.typeAmplitude = Variable(.slider)
            self.typeFrequency = nil
        }else{
            self.typeAmplitude = nil
            self.typeFrequency = Variable(.button)
        }
        
        self.possibleValues = possibleValues
        self.index = Variable(possibleValues.index(of: value) ?? 0)
    }

    var values: Observable<Int> {
        return index.asObservable().map { self.possibleValues[$0] }
    }

    var sliderSelected: Observable<Bool> {
        if let type = typeFrequency.value{
            return type.asObservable().map { $0 == .slider }
        }
        if let type = typeAmplitude.value {
            return type.asObservable().map { $0 == .slider }
        }
        return Variable(FrequencySteppedType.button).asObservable().map{ $0 == .slider }
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
