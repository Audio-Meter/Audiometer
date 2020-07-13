//
//  WordPlayerIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import os

class WordPlayerIdea {
    let test: TestIdea
    let conductionIdea: ConductionIdea
    let type = Variable(SpeechType.srt)
    let srtSdType = Variable(IndexPath(row: 0, section: 0))
    let word: Variable<Word?> = Variable(nil)
    let syncService = SyncAudioManager()
    var currentCategoryIndex = Variable(0)

    init(test: TestIdea, conductionIdea: ConductionIdea) {
        self.test = test
        self.conductionIdea = conductionIdea
    }

    var typeVariable: Observable<Void> {
        return srtSdType.asObservable().map {
            switch $0.row {
                case 0: self.type.value = SpeechType.srt
                case 1: self.type.value = SpeechType.sd
                default: break
            }
        }
    }
    
    func syncAudio(completion: @escaping (Error?) -> ()) {
        syncService.syncAudio { [weak self] (error) in
            self?.test.app.words.updateCategories()
            completion(error)
        }
    }

    var playlist: Observable<[Word]> {
        let typeObserve = type.asObservable().map {_ in 
            return self.test.app.words.list(type: self.type.value, index: self.currentCategoryIndex.value)
        }
        let indexObserve = currentCategoryIndex.asObservable().map {_ in
            return self.test.app.words.list(type: self.type.value, index: self.currentCategoryIndex.value)
        }
        return Observable.of(typeObserve, indexObserve).merge()
    }

    func play(taps: Observable<Void>) -> Disposable {
        let events = taps.filter { self.word.value == nil }
        return events.withLatestFrom(playlist).scan(to: word) { _, list in
            return list.first
        }
    }

    func stop() {
        word.value = nil
    }

    var config: Observable<WordConfig> {
        return Observable.combineLatest(test.isPlayed, test.amplitude, test.calibration(type: .word), test.pan, word.asObservable()) {
            WordConfig(isPlayed: $0, dBHL: $1, calibration: $2, pan: $3, word: $4, looping: false)
        }
    }

    func nextWord(events: Observable<Void>) -> Disposable {
        return events.withLatestFrom(playlist).scan(to: word) { word, list in
            guard let word = word else {
                return nil
            }
            guard let index = list.index(of: word) else {
                return nil
            }
            guard index < list.count - 1 else {
                return nil
            }
            return list[index + 1]
        }
    }
    
    

    var wordChanged: Observable<Void> {
        return word.asObservable().void()
    }

    var typeChanged: Observable<Void> {
        return Observable.merge(
            type.asObservable().void(),
            conductionIdea.conductions.map { $0.forWord() }.distinctUntilChanged().void()
        )
    }

    var isPlaying: Observable<Bool> {
        return word.asObservable().map { $0 != nil }
    }

    var didStopped: Observable<Void> {
        return word.asObservable().distinctUntilChanged().filter { $0 == nil }.void()
    }
}
