//
//  WordTestPage.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/28/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxSwiftExt

class WordTestPage {
    let app: App
    let amplitudeModel = SteppedViewModel(possibleValues: Metric.amplitudes, value: 50)
    let transducerModel: TransducerPickerIdea

    let wordStat = Variable(SpeechTestStat.zero)
    var result: WordTestResultViewModel!
    let playedVar = Variable(false)
    var report: Report = Report()
    //var category: Variable<[String]> = Variable([])
    private let disposeBag = DisposeBag()
    
    let mclComfortLevelSelected = Variable(false)
    let uclComfortLevelSelected = Variable(false)
    let patientId: String

    init(app: App, patientId: String, report: Report) {
        self.app = app
        self.transducerModel = TransducerPickerIdea(app: app)
        self.patientId = patientId
        result = WordTestResultViewModel(patientId: patientId, comment: "")
        self.report = report
        self.conductionIdea.conductions.asObservable().subscribe(onNext: { [weak self] value in
            self?.updateComfortLevelsStates()
        }).disposed(by: disposeBag)
        
        
        result.values.asObservable().subscribe(onNext: { [weak self] value in
            self?.updateComfortLevelsStates()
        }).disposed(by: disposeBag)
    }
    
    private func updateComfortLevelsStates() {
        let channel = conductionIdea.channel.value
        guard let conduction = Conduction.create(index: conductionIdea.conductionIndex.value, channel: channel) else {
            return
        }
        let mclExsist = isAmplitudeValueExistInResults(conduction: conduction, comfortLevel: .mcl)
        mclComfortLevelSelected.value = mclExsist
        
        let uclExsist = isAmplitudeValueExistInResults(conduction: conduction, comfortLevel: .ucl)
        uclComfortLevelSelected.value = uclExsist
    }

    var transducer: Observable<Transducer> {
        return transducerModel.selectedItem.asObservable()
    }

    var amplitude: Observable<Int> {
        return amplitudeModel.values
    }
    
    var category: Observable<[String]>{
       return player.test.app.words.category.asObservable()
    }

    func pause() {
         playedVar.value = false
    }

    var playButton: Observable<ButtonIdea> {
        return playedVar.asObservable().map { $0 ? .stop : .play }
    }

    func pause2(taps: Observable<Void>) -> Disposable {
        return taps.scan(to: playedVar) { played, _ in
            return !played
        }
    }

    func didPlayed() -> SpeechTestStat {
        return wordStat.value.played()
    }
    
    func markAsPlayed(file: String?) {
        guard let file = file else {
            return
        }
        wordStat.value = wordStat.value.markAsPlayed(file: file)
    }
    
    func markAsCorrect(file: String?) {
        wordStat.value = wordStat.value.markAsCorrect()
    }
    
    func skip(file: String?)  {
        guard let file = file else {
            return
        }
        wordStat.value = wordStat.value.skip(file: file)
    }

    func wrong(file: String?) {
        wordStat.value = wordStat.value.wrong()
    }
    
    func zeroStat() -> SpeechTestStat {
        return .zero
    }

    func reset(taps: Observable<Void>) -> Disposable {
        let values = Observable.combineLatest(conductionIdea.conductions, amplitude, wordStat.asObservable())
        
        return taps.withLatestFrom(values).scan(to: result.values) { result, value in
            if self.player.type.value == .srt {
                return result.update(conduction: value.0, srt: nil)
            } else {
                return result.update(conduction: value.0, sd: nil)
            }
        }
    }

    
    func score(taps: Observable<Void>) -> Disposable {
        let values = Observable.combineLatest(conductionIdea.conductions, amplitude, wordStat.asObservable())
        return taps.withLatestFrom(values).scan(to: result.values) { result, value in            
            if self.player.type.value == .srt {
                return result.update(conduction: value.0, srt: value.1)
            } else {
                var percent: Int = 0
                let wordsResult = value.2
                if wordsResult.playedCount > 0 {
                    percent = Int((Double(wordsResult.correctCount) / Double(wordsResult.playedCount)) * 100.0)
                }
                return result.update(conduction: value.0, sd: percent)
            }
        }
    }
    
    var wordStats: Observable<SpeechTestStat> {
        return player.wordChanged.withLatestFrom(wordStat.asObservable())
    }

    var playedCount: Observable<String> {
        return wordStat.asObservable().map { String($0.playedCount) }
    }

    var correctCount: Observable<String> {
        return wordStat.asObservable().map { String($0.correctCount) }
    }

    func comfortLevel(levels: Observable<ComfortLevel>) -> Disposable {
        let values = Observable.combineLatest(conductionIdea.conductions, amplitude)
        return levels.withLatestFrom(values) {
            (level: $0, conduction: $1.0, amplitude: $1.1)
        }.scan(to: result.values) { result, value in
            if let comfortLevel = result.comfortLevels[value.level] {
                if  comfortLevel[value.conduction] != nil {
                    return result.delete(comfortLevel: value.level, conduction: value.conduction, amplitude: value.amplitude)
                }
            }
            return result.update(comfortLevel: value.level, conduction: value.conduction, amplitude: value.amplitude)
        }
    }
    
    func removeComfortLevel(levels: Observable<ComfortLevel>) -> Disposable {
        let values = Observable.combineLatest(conductionIdea.conductions, amplitude)
        return levels.withLatestFrom(values) {
            (level: $0, conduction: $1.0, amplitude: $1.1)
            }.scan(to: result.values) { result, value in
                result.update(comfortLevel: value.level, conduction: value.conduction, amplitude: value.amplitude)
        }
    }
    
    private func isAmplitudeValueExistInResults(conduction: Conduction, comfortLevel: ComfortLevel) -> Bool {
        let values = result.values.value
        if let info = values.comfortLevels[comfortLevel] {
            if info[conduction] != nil {
                return true
            }
        }
        return false
    }

    lazy var testIdea: TestIdea = {
        return TestIdea(
            app: app,
            isPlayed: playedVar.asObservable(),
            frequency: .just(1000),
            amplitude: amplitude,
            pan: conductionIdea.pans,
            transducer: transducer
        )
    }()

    let conductionIdea = ConductionIdea()

    lazy var masking: MaskingIdea = {
        return MaskingIdea(test: testIdea)
    }()

    lazy var player: WordPlayerIdea = {
        return WordPlayerIdea(test: testIdea, conductionIdea: conductionIdea)
    }()
    
    func syncAudio(completion: @escaping (Error?) -> ()) {
        self.player.syncAudio(completion: completion)
    }
    
    func testResultPage(taps: Observable<Void>) -> Observable<TestResultPage<WordTestResult>> {
        return taps.map { _ in
            let test = self.result.values.value
            return TestResultPage(app: self.app, testResult: test, report: self.report)
        }
    }
}
