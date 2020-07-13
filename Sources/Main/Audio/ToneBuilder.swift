//
//  ToneBuilder.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/14/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit
import RxSwift

struct ToneBuilder {
    let settings: Observable<ToneSettings>
    let played: Observable<Bool>
    let stopped: Observable<Void>
    let toneSetting: Observable<ToneSendSetting>

    var steady: AKFMOscillator {
        let node = AKFMOscillator()
        
//        if AgoraRtm.rtmChannel != nil{
            configure(node, toneSetting.map { config in
                node.baseFrequency = config.basefrequency
                node.amplitude = config.amplitude
                if config.modulatingMultiplier == nil && config.pulseFreq == nil{
                    node.start()
                    
                }else{
                    
                    node.stop()
                }
            })
//        }else{
            configure(node, settings.map { config in
                node.baseFrequency = Double(config.frequency)
                node.amplitude = (config.toneType.isPulsed ? 0 : config.fs(dBHL: config.dBHL))
                if case .steady = config.toneType {
                    node.start()
                }else{
                    node.stop()
                }
            })
//        }
        
        node.start()
        return node
    }

    var warble: AKFMOscillator {
        let node = AKFMOscillator()
        
//        if AgoraRtm.rtmChannel != nil{
            configure(node, toneSetting.map { config in
                if let modulationMultiplier = config.modulatingMultiplier, let index = config.modulationIndex{
                    node.modulatingMultiplier = modulationMultiplier
                    node.modulationIndex = index
                    node.amplitude = config.amplitude
                    node.start()
                    
                } else {
                    
                    node.modulatingMultiplier = 1
                    node.modulationIndex = 1
                    node.stop()
                }
            })
//        }else{
            configure(node, settings.map { config in
                if case .warble(let index, let multiplier) = config.toneType {
                    node.modulatingMultiplier = multiplier / Float(config.frequency)
                    node.modulationIndex = index
                    node.amplitude = config.fs(dBHL: config.dBHL)
                    node.start()
                } else {
                    node.modulatingMultiplier = 1
                    node.modulationIndex = 1
                    node.stop()
                }
            })
//        }
        
        node.start()
        return node
    }

    //TODO: Don't use AKOperationGenerator
    var pulsed: AKNode {
        let generator = AKOperationGenerator() { _ in
            let sine = AKOperation.sineWave(
                frequency: AKOperation.parameters[0],
                amplitude: AKOperation.parameters[1]
            )
            let metronome = AKOperation.metronome(frequency: AKOperation.parameters[2])
            return sine.triggeredWithEnvelope(trigger: metronome, hold: 0.0)
        }
        

        let booster = AKBooster(generator, gain: 0)
//        if AgoraRtm.rtmChannel != nil{
            configure(booster, toneSetting.map { config in
                generator.parameters[0] = config.basefrequency
                generator.parameters[1] = config.amplitude
                if let freq = config.pulseFreq{
                        generator.parameters[2] = freq
                        booster.gain = 1
                        generator.start()
                        
                    } else {
                        generator.parameters[2] = 1
                        booster.gain = 0
                        generator.stop()
                    
                    }
                })
//        }else{
            configure(booster, settings.map { config in
                    generator.parameters[0] = Double(config.frequency)
                    generator.parameters[1] = config.fs(dBHL: config.dBHL)
            
                    if case .pulsed(let frequency) = config.toneType {
                        generator.parameters[2] = frequency
                        booster.gain = 1
                        generator.start()
                    } else {
                        generator.parameters[2] = 1
                        booster.gain = 0
                        generator.stop()
                    }
                })
//        }

        
        start(generator)
        return booster
    }

    var tone: AKNode {
        let steady = self.steady
        let pulsed = self.pulsed
        let warble = self.warble
        let mixer = AKMixer(steady,warble, pulsed)
        let booster = AKBooster(mixer, gain: 0)
        configure(booster, played.map {
            booster.gain = $0 ? 1 : 0            
        })
                
        return booster
    }

    var output: AKNode {
        let panner = AKPanner(tone, pan: Channel.left.pan)
        configure(panner, settings.map { config  in
            panner.pan = config.pan
        })
        configure(panner, toneSetting.map{ config in
            print(config.pan)
            panner.pan = config.pan
        })
        
        return panner
    }

    private func configure(_ node: AKNode, _ observable: Observable<Void>) {
        _ = observable.takeUntil(stopped).subscribe()
    }
            
    private func start(_ node: AKToggleable) {
        node.start()
        _ = stopped.subscribe(onNext: { _ in
            node.stop()
        })
    }
}
