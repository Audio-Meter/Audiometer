//
//  MaskingPlayer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/28/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit
import RxSwift
import RxCocoa


struct MaskingTest :Codable{
    
    let amplitude:Double
    let volume:Double
    let audioFileName:String?
    let isPlaying:Bool
    let pan:Double
    
    func getData() -> Data?{
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    static func getToneSendSettings(fromData data:Data) -> MaskingTest?{
        let decoder = JSONDecoder()
        return try? decoder.decode(MaskingTest.self, from: data)
    }
    
    
}

struct MaskingConfig: TestConfig {
    let isPlayed: Bool
    let dBHL: Int

    let calibration: Calibration
    let baseFrequency: Int
    let pan: Double

    let type: MaskingType

    var frequency: Int {
        if type == .nbn {
            return baseFrequency
        } else {
            return 1000
        }
    }
    
    var leftChannelPan: Double {
        return -1
    }
    
    var rightChannelPan: Double {
        return 1
    }

    var wnAmplitude: Double {
        return type == .wn ? amplitude : 0
    }

    var fileAmplitude: Double {
//        let amplitude = calibration.fs(frequency: frequency, dBHL: dBHL + 54)
        let amplitude = calibration.fs(frequency: frequency, dBHL: dBHL)
        return amplitude

//        return type == .wn ? 0 : amplitude
    }

    var isFilePlaying: Bool {
        return isPlayed && type != .wn
    }

    var audioFile: AKAudioFile? {
        return type == .wn ? nil : type.file(frequency: frequency)
    }
    
    var audioFileName:String?{
        return type == .wn ? nil : type.fileName(frequency: frequency)
    }
    
    func getMaskingSetting() -> MaskingTest{        
        return MaskingTest(amplitude: self.wnAmplitude, volume: self.fileAmplitude, audioFileName: self.audioFileName, isPlaying: self.isFilePlaying, pan: self.pan)
    }
}

class MaskingPlayer: AudioPlayer, ReactiveCompatible {
    let wn = AKWhiteNoise(amplitude: 0)
    let player = try! AKAudioPlayer(file: .empty)

    lazy var mixer: AKMixer = {
        return AKMixer(wn, player)
    }()

    lazy var panner: AKPanner = {
        return AKPanner(self.mixer)
    }()

    init() {
        wn.start()
        player.looping = true
    }

    deinit {
        wn.stop()
    }

    var node: AKNode {
        return panner
    }

    func update(config: MaskingConfig) {
        wn.amplitude = config.wnAmplitude
        player.volume = config.fileAmplitude
        config.audioFile?.play(in: player)
        player.setStarted(config.isFilePlaying)
                
        if appDelegate.isFromCalibration == true {
            panner.pan = config.pan
        } else {
            if config.pan == config.leftChannelPan {
                panner.pan = config.rightChannelPan
            }
            else if config.pan == config.rightChannelPan {
                panner.pan = config.leftChannelPan
            }
            else {
                panner.pan = config.pan
            }
        }
    }
    
    func update(_ test:MaskingTest){
        wn.amplitude = test.amplitude
        player.volume = test.volume
        if let name = test.audioFileName, let audioFile = try? AKAudioFile(readFileName: name){
            player.setAudioFile(audioFile)
        }
        
        if test.pan == 0 {
            player.volume = 0
            wn.amplitude = 0
        }

        panner.pan = -test.pan        
    }
    
    
}

extension Reactive where Base: MaskingPlayer {
    var config: Binder<MaskingConfig> {
        return Binder(base) { player, config in
            player.update(config: config)
        }
    }
}
