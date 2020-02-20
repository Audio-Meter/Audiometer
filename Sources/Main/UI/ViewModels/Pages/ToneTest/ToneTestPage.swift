//
//  ToneTestPage.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class ToneTestPage {
    let app: App

    let audiogramVar = Variable(Audiogram())
    let frequencyModel = SteppedViewModel(possibleValues: Metric.frequencies, value: 1500)
    let amplitudeModel = SteppedViewModel(possibleValues: Metric.amplitudes, value: 50)
    let transducerModel: TransducerPickerIdea
    let playedVar = Variable(false)
    var report: Report
    private let patientId: String

    init(app: App, patientId: String, report: Report) {
        self.app = app
        self.transducerModel = TransducerPickerIdea(app: app)
        self.patientId = patientId
        self.report = report
    }

    var frequency: Observable<Int> {
        return frequencyModel.values
    }

    var amplitude: Observable<Int> {
        return amplitudeModel.values
    }

    var transducer: Observable<Transducer> {
        return transducerModel.selectedItem.asObservable()
    }

    var audiogram: Observable<Audiogram> {
        return audiogramVar.asObservable()
    }

    func testResultPage(taps: Observable<Void>) -> Observable<TestResultPage<TestResult>> {
        return taps.map { _ in
            let result = TestResult(id: nil, date: Date(), patientId: self.patientId, comment: "", audiogram: self.audiogramVar.value)
            return TestResultPage(app: self.app, testResult: result, report: self.report)
        }
    }

    func play() {
        playedVar.value = true
    }

    func pause() {
        playedVar.value = false
    }

    var playButton: Observable<ButtonIdea> {
        return playedVar.asObservable().map { $0 ? .stop : .play }
    }

    func passed() -> Bool {
        return true
    }

    func failed() -> Bool {
        return false
    }

    func record(_ passed: Observable<Bool>) -> Disposable {
        return audiogramEntry(passed: passed).scan(to: audiogramVar) { value, entry in
            value.put(entry)
        }
    }

    func clearAt(_ entries: Observable<Audiogram.Entry>) -> Disposable {
        return entries.scan(to: audiogramVar) { audiogram, entry in
            return audiogram.remove(entry)
        }
    }

    func clearAll(_ taps: Observable<Void>) -> Disposable {
        return taps.scan(to: audiogramVar) { _, _ in
            return Audiogram()
        }
    }

    var audiogramKey: Observable<Audiogram.Key> {
        return Observable.combineLatest(conductionIdea.conductions, frequency) {
            return AudiogramKey(conduction: $0, frequency: $1)
        }
    }

    func audiogramValue(passed: Observable<Bool>) -> Observable<AudiogramValue> {
        let values = Observable.combineLatest(amplitude, masking.isEnabled.asObservable())
        return passed.withLatestFrom(values) { passed, values in
            return AudiogramValue(amplitude: values.0, masked: values.1, passed: passed)
        }
    }

    func audiogramEntry(passed: Observable<Bool>) -> Observable<Audiogram.Entry> {
        return audiogramValue(passed: passed).withLatestFrom(audiogramKey) { value, key in
            return (key, value)
        }
    }

    lazy var testIdea: TestIdea = {
        return TestIdea(
            app: app,
            isPlayed: playedVar.asObservable(),
            frequency: frequency,
            amplitude: amplitude,
            pan: conductionIdea.pans,
            transducer: transducer
        )
    }()

    let conductionIdea = ConductionIdea()

    lazy var masking: MaskingIdea = {
        return MaskingIdea(test: testIdea)
    }()

    lazy var player: TonePlayerIdea = {
        return TonePlayerIdea(test: testIdea)
    }()
}
