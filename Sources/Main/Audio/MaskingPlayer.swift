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
}

extension Reactive where Base: MaskingPlayer {
    var config: Binder<MaskingConfig> {
        return Binder(base) { player, config in
            player.update(config: config)
        }
    }
}
