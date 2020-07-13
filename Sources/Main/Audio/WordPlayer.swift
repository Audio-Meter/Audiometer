//
//  WordPlayer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/1/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import os
import AudioKit
import RxSwift
import RxSwiftExt
import RxCocoa


struct WorkTestSetting:Codable{
    var isStarted:Bool
    let isPlayed:Bool
    let volume:Double
    let pan:Double
    let looping:Bool
    let type: Int?
    let text: String?
    var localPath: String?
    var category: String
    let timeStartPos: Double?
    let timeEndPos: Double?
    
    func getData() -> Data?{
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    static func getToneSendSettings(fromData data:Data) -> WorkTestSetting?{
        let decoder = JSONDecoder()
        return try? decoder.decode(WorkTestSetting.self, from: data)
    }
}

struct WordConfig: TestConfig {
    let isPlayed: Bool
    let dBHL: Int
    
    let calibration: Calibration
    let pan: Double
    let word: Word?
    let looping: Bool
    
    var frequency: Int {
        return 1000
    }
    
    var isStarted: Bool {
        return word != nil
    }
    
    func getWordSendSettings() -> WorkTestSetting{                
        return WorkTestSetting(isStarted: self.isStarted, isPlayed: self.isPlayed, volume: self.amplitude, pan: self.pan, looping: self.looping, type: self.word?.type.hashValue ?? SpeechType.srt.rawValue, text: self.word?.text, localPath: self.word?.path, category: localCategory, timeStartPos: self.word?.timeStartPos, timeEndPos: self.word?.timeEndPos)
    }
    
    func getNextWord(){
        
    }
    
}

class WordPlayer: NSObject, AudioPlayer {
    let player = try! AKAudioPlayer(file: .empty)
    
    //    let avSpeechSynthesizer = AVSpeechSynthesizer()
    
    //    private let completed = PublishRelay<URL>()
    let completed = PublishRelay<String>()
    let isPlaying = Variable(false)
    var currentPlayingFile: String?
    var currentPlayingFilePath: String?
    
    override init() {
        super.init()
        player.completionHandler = { [weak self] in
            guard let `self` = self else { return }
            
            if(self.currentPlayingFile != nil) {
//                os_log("finish word: %s", self.currentPlayingFile!)
                
                self.completed.accept(self.currentPlayingFile!)
            }
        }
        //        avSpeechSynthesizer.delegate = self
    }
    
    deinit {
        player.stop()
        //        avSpeechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    var node: AKNode {
        return player
    }
    
    var didPlayed: Observable<Void> {
        return completed.asObservable().void()
    }
    
    func next(playing: Observable<Bool>) -> Observable<Void> {
        let finish = completed.flatMap { [weak self] file -> Observable<String> in
            self?.isPlaying.value = false
            return Observable.merge(Rx.timer(3), playing.void()).take(1).mapTo(file)
        }
        currentPlayingFile = nil
        currentPlayingFilePath = nil
        if !player.isStopped {
            player.stop()
        }
        return finish.pausableBuffered(playing)
            .filter {
                os_log("%s", $0)
                return $0 == self.currentPlayingFile
        }.void()
    }
    
    //    func getUtteranceWithDelay(text: String, preUtteranceDelayInSecond: Int, postUtteranceDelayInSecond: Int) -> AVSpeechUtterance {
    //      let utterance = getUtterance(text)
    //      utterance.preUtteranceDelay = TimeInterval.init(exactly: preUtteranceDelayInSecond)!
    //      utterance.postUtteranceDelay = TimeInterval.init(exactly: postUtteranceDelayInSecond)!
    //      return utterance
    //    }
    
    //    func getUtterance(_ speechString: String) -> AVSpeechUtterance {
    //      let utterance = AVSpeechUtterance(string: speechString)
    //      utterance.voice = AVSpeechSynthesisVoice(language: "en")
    //      utterance.rate =  0.5
    //      utterance.pitchMultiplier = 1.0
    //      utterance.volume = Float(player.volume)
    ////      utterance.preUtteranceDelay = ...
    ////      utterance.postUtteranceDelay = ...
    //      return utterance
    //    }
    
    func play(word: Word?) {
        guard let word = word else { return }
        
        
        if currentPlayingFilePath != word.localPath {
            if player.isPlaying{
                player.pause()            
            }
            try! player.replace(file: word.file)
            
            let url = Bundle.main.path(forResource: "\(word.text).wav", ofType:nil)!
            currentPlayingFilePath = url
            if !player.isPlaying{
                player.start()
            }
            
        }else{
            
        }
        if !player.isPlaying{
            player.start()
        }
        
        currentPlayingFile = word.text
        
        if word.timeEndPos > 0 {
            player.startTime = word.timeStartPos
            player.play(from: word.timeStartPos, to: word.timeEndPos)
            
        } else {
            
            player.resume()
        }
        
        isPlaying.value = true
    }
    
    func update(config: WordConfig) {
        if config.isStarted {
            player.setPlaying(config.isPlayed)
        }
        
        if (AgoraRtm.rtmChannel != nil) {
            player.volume = 0
        }else{
            player.volume = config.amplitude
        }
        
        
        player.pan = config.pan
        player.looping = config.looping
    }
    
    func stopWordPlayerForPatient(){
        print("Player stoped")
    }
    
    func update(config:WorkTestSetting){
        
        player.volume = config.volume
        player.pan = config.pan
        player.looping = config.looping
        if let text = config.text, let localPath = config.localPath, let start = config.timeStartPos, let end = config.timeEndPos{
            print("Will play word - \(text)")
            let speech = SpeechType(rawValue: config.type ?? 0) ?? SpeechType.srt
            self.playForPatient(word: Word(type: speech, text: text, localPath: localPath, category: config.category, startPos: start, endPos: end))
        }else{
            print("word not played self \(config.text ?? "")")
        }
    }
    
    func playForPatient(word: Word?) {
        guard let word = word else { return }                        
//            let url = Bundle.main.path(forResource: "\(word.text).wav", ofType:nil)!
//            currentPlayingFilePath = url
            if player.isPlaying{
                print("pause then playing")
                player.pause()
                try! player.replace(file: word.file)
                player.play()
            }else{
                print("isplayinng")
                try! player.replace(file: word.file)
                player.play()
            }
            isPlaying.value = true
    }
}

//extension WordPlayer: AVSpeechSynthesizerDelegate {
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) { }
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
////        guard let `self` = self else { return }
//        self.completed.accept(self.player.audioFile.url)
//
////        return completed.asObservable().void()
//    }
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) { }
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) { }
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) { }
//}

func ||>(configs: Observable<WordConfig>, player: WordPlayer) -> Disposable {
    return Disposables.create(
        configs.map { $0.word }.distinctUntilChanged().subscribe(onNext: player.play),
        configs.subscribe(onNext: player.update)
    )
}

