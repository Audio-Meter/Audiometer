//
//  CalibrationPage.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class CalibrationPage {
    let app: App
    let transducerModel: TransducerPickerIdea
    let conductionIdea = ConductionIdea()

    let typeIndex = Variable(IndexPath(row: 0, section: 0))
    let frequencyIndex = Variable(IndexPath(row:0,section: 0))
    let stepIndex = Variable(IndexPath(row:0,section: 0))
    let calibration = Variable(Calibration.zero)

    let play = PlayButtonIdea()

    init(app: App) {
        self.app = app
        self.transducerModel = TransducerPickerIdea(app: app)
        conductionIdea.conductionIndex.value = Conduction.soundfield.index
    }

    var transducer: Observable<Transducer> {
        return transducerModel.selectedItem.asObservable()
    }

    var type: Observable<CalibrationType> {
        return typeIndex.asObservable().map {
            switch $0.row {
            case 0: return .tone
            case 1: return .word // changed by maulik ob 30 NOV 2018
            default: return .masking(MaskingType(rawValue: $0.row - 2)!)
            }
        }
    }

    var types:[String]{
        var arr = CalibrationType.allText
        arr.append(contentsOf: MaskingType.allText)
        return arr
    }
    
    // changed by maulik ob 30 NOV 2018
    
    var isFrequencyEnabled: Observable<Bool> {
        return typeIndex.asObservable().map {
            switch $0.row {
            case 0: return true
            case 1: return false
            case 2: return false
            case 3: return true
            case 4: return false
            case 5: return false
            default: return true
            }
        }
    }
    
//    var isFrequencyEnabled: Observable<Bool> {
//        return type.map {
//            switch $0 {
//            case .tone, .masking(.nbn): return true
//            default: return false
//            }
//        }
//    }

    var frequencyDidDisabled: Observable<Void> {
        return isFrequencyEnabled.filter { $0 == false }.void()
    }

    func setDefaultFrequency() {
        frequencyIndex.value = IndexPath(row: 4, section: 0)
    }

    lazy var loadedCalibration: Observable<Calibration> = {
        return Observable.combineLatest(transducer, type, conductionIdea.pans) { [weak self] in
            guard let `self` = self else { fatalError() }
            return self.app.calibrations.load(transducer: $0, type: $1, pan: $2)
        }.share(replay: 1, scope: .whileConnected)
    }()

    var isTonePlaying: Observable<Bool> {
        
        return Observable.combineLatest(typeIndex.asObservable(), play.isPlaying.asObservable()) {
//            $0 == 0 && $1 // changed by maulik ob 30 NOV 2018
            
//            if ($0 == 0 || $0 == 1) && $1 == true{
//                return true
//            } else {
//                return false
//            }
            
            if ($0.row == 0) && $1 == true{ //10th Jan Change for new speech
                return true
            } else {
                return false
            }
        }
    }

    var toneConfigs: Observable<ToneSettings> {
        return Observable.combineLatest(
            calibration.asObservable(),
            conductionIdea.pans,
            frequency
        ) { calibration, pan, frequency in
            
//            if self.play.isPlaying.value == true {
//                self.play.pause()
//            }
//
//            if self.typeIndex.value == 1 {
////                sleep(1)
//            }
            
//            if self.play.isPlaying.value == true {
//                self.play.play()
//            }
            
            return ToneSettings(
                calibration: calibration,
                pan: pan,
                toneType: .steady,
                frequency: frequency,
                dBHL: 70
            )
        }
    }
    
    // Changed on 04/01/2019 by maulik
    
//    var toneConfigs: Observable<ToneSettings> {
//        return Observable.combineLatest(
//            calibration.asObservable(),
//            conductionIdea.pans,
//            frequency
//        ) { calibration, pan, frequency in
//            if self.typeIndex.value == 0 {
//                return ToneSettings(
//                    calibration: calibration,
//                    pan: pan,
//                    toneType: .steady,
//                    frequency: frequency,
//                    dBHL: 70
//                )
//            } else {
//                return ToneSettings(
//                    calibration: calibration,
//                    pan: pan,
//                    toneType: .steady,
//                    frequency: frequency,
//                    dBHL: 70
//                )
//            }
//        }
//    }

    var wordConfigs: Observable<WordConfig> {
        let word = app.words.calibration
        return Observable.combineLatest(
            typeIndex.asObservable(),
            play.isPlaying.asObservable(),
            calibration.asObservable(),
            conductionIdea.pans) {
                let isPlayed = $0.row == 1 && $1
                return WordConfig(
                    isPlayed: isPlayed,
                    dBHL: 70,
                    calibration: $2,
                    pan: $3,
                    word: isPlayed ? word : nil,
                    looping: true
                )
        }
    }

    var noiseConfigs: Observable<MaskingConfig> {
        return Observable.combineLatest(
            typeIndex.asObservable(),
            play.isPlaying.asObservable(),
            calibration.asObservable(),
            conductionIdea.pans,
            frequency) {
                let type = MaskingType(rawValue: $0.row - 2)
                
                return MaskingConfig(isPlayed: $0.row > 1 && $1, dBHL: 70, calibration: $2, baseFrequency: $4, pan: $3, type: type ?? .wn)
        }
    }

    var frequency: Observable<Int> {
        return frequencyIndex.asObservable().map { Metric.frequencies[$0.row] }
    }

    let frequencies = Metric.frequencies.map { String($0) }
    let steps: [Double] = [2, 1, 0.5]

    func playButton(played: Bool) -> ButtonIdea {
        return played ? .stop : .play
    }

    func played(taps: Observable<Void>) -> Observable<Bool> {
        return taps.enumerated().map { $0.index % 2 == 0 }
    }

    func increment() -> Double {
        return +1
    }

    func decrement() -> Double {
        return -1
    }
    
    func put(_ signs: Observable<Double>) -> Disposable {
        return signs.scan(to: calibration) { [weak self] calibration, sign in
            guard let `self` = self else { return calibration }
            let step = sign * self.steps[self.stepIndex.value.row]
            let freq = Metric.frequencies[self.frequencyIndex.value.row]
            return calibration.append(frequency: freq, value: step)
        }
    }

    func save(taps: Observable<Void>) -> Disposable {
        let values = Observable.combineLatest(
            transducer, type, conductionIdea.pans, calibration.asObservable()
        )
        return taps.withLatestFrom(values).subscribe(onNext: { [weak self] in
            self?.app.calibrations.save(transducer: $0.0, type: $0.1, pan: $0.2, calibration: $0.3)
        })
    }

    func restore(_ taps: Observable<Void>) -> Disposable {
        return taps.withLatestFrom(loadedCalibration).scan(to: calibration) { _, loaded in
            return loaded
        }
    }
}
