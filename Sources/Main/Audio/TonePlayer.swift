//
//  TonePlayer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/12/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit
import RxSwift
import RxCocoa

struct ToneSendSetting:Codable {
    let pan: Double
    let basefrequency:Double
    let amplitude:Double
    let modulatingMultiplier:Double?
    let modulationIndex: Double?
    let type:String
    let pulseFreq :Double?
    
    func getData() -> Data?{
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    static func getToneSendSettings(fromData data:Data) -> ToneSendSetting?{
        let decoder = JSONDecoder()
        return try? decoder.decode(ToneSendSetting.self, from: data)
    }
    
    func observableFunc() -> Observable<ToneSendSetting> {
           return Observable.create { observer in
                       observer.onNext(self)
                       observer.onCompleted()            
               return Disposables.create()
           }
       }
        
    
}

struct ToneSettings {
    let calibration: Calibration
    let pan: Double
    let toneType: ToneType
    let frequency: Int
    let dBHL: Int

    func fs(dBHL: Int) -> Double {
        return calibration.fs(frequency: frequency, dBHL: dBHL)
    }
    
    
    func getToneSendSettings() -> ToneSendSetting{
        var modulatingMultiplier:Double?
        var modulationIndex:Double?
        var pulsedFreq :Double?
        if case .warble(let index, let multiplier) = self.toneType {
            modulatingMultiplier = multiplier / Float(self.frequency)
            modulationIndex = index
        }
        if  case .pulsed(let freq) = self.toneType{
            pulsedFreq = freq
        }
        
        
        let amplitude = self.fs(dBHL: self.dBHL)
        let frequency = Double(self.frequency)
        
        
        return ToneSendSetting(pan: self.pan, basefrequency: frequency, amplitude: amplitude, modulatingMultiplier: modulatingMultiplier, modulationIndex: modulationIndex, type: self.toneType.typeName, pulseFreq: pulsedFreq)
    }
    
    
}

class TonePlayer: ReactiveCompatible, AudioPlayer {
    let played = PublishRelay<Bool>()
    let settings = PublishRelay<ToneSettings>()
    let toneSendSetting = PublishRelay<ToneSendSetting>()

    var node: AKNode {
        let builder = ToneBuilder(settings: settings.asObservable(), played: played.startWith(false), stopped: rx.deallocated, toneSetting: toneSendSetting.asObservable())
        return builder.output
    }

    func play() {
        played.accept(true)
    }

    func stop() {
        played.accept(false)
    }
}
