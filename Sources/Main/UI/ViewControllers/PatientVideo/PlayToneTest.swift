//
//  PlayToneTest.swift
//  Audiometer
//
//  Created by Arun Jangid on 10/05/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import Foundation
import AudioKit

class PlayToneTest{
    
    
    
    var oscillator = AKOscillator()
    var booster = AKBooster()
    var generatorCheck: AKOperationGenerator!
    var steadyOscillator = AKFMOscillator()
    var warbleOscillator = AKFMOscillator()
    var isPlaying = false
    var currentToneSetting : ToneSendSetting?
    
    
    
    func playSound() {
                
        if isPlaying == true{
//            booster.gain = 1
            switch currentToneSetting?.type {
            case "s":
                
                playSteady()
                
                generatorCheck.stop()
                oscillator.start()
                warbleOscillator.stop()
            case "p":
                oscillator.stop()
                warbleOscillator.stop()
                playPulse()                
                generatorCheck.start()
                
            case "w":
                playWarble()
                generatorCheck.stop()
                oscillator.stop()
                warbleOscillator.start()
            default:
                break
            }
        }else{
            if generatorCheck != nil {
                generatorCheck.stop()
                oscillator.stop()
                warbleOscillator.stop()
            }
            
        }
    }
    
    func stopAll(){
        if generatorCheck != nil {
            generatorCheck.stop()
            oscillator.stop()
            warbleOscillator.stop()
            do {
                try AudioKit.stop()
            } catch {
                AKLog("AudioKit did not start!")
            }
        }
            
        
    }
    
    func pulse() -> AKOperationGenerator{
        let generator = AKOperationGenerator() { _ in
            let sine = AKOperation.sineWave(
                frequency: AKOperation.parameters[0],
                amplitude: AKOperation.parameters[1]
            )
            let metronome = AKOperation.metronome(frequency: AKOperation.parameters[2])
            return sine.triggeredWithEnvelope(trigger: metronome, hold: 0.0)
        }
                        
        generator.parameters[0] = currentToneSetting?.basefrequency ?? 1500
        generator.parameters[1] = currentToneSetting?.amplitude ?? 0.32009029388427734
        generator.parameters[2] = currentToneSetting?.pulseFreq ?? 1.0
        
        return  generator
    }
    
    
    
    func playPulse(){
        generatorCheck = pulse()
        
    }
    func playSteady(){
        oscillator.amplitude = currentToneSetting?.amplitude ?? 1500
        oscillator.frequency = currentToneSetting?.basefrequency ?? 50
        
    }
    
    func playWarble(){
        warbleOscillator.modulatingMultiplier = currentToneSetting?.modulatingMultiplier ?? 0
        warbleOscillator.modulationIndex = currentToneSetting?.modulationIndex ?? 0
    }
    
    func mixAll(){
        playSteady()
        playWarble()
        playPulse()
        let mixer = AKMixer(oscillator,warbleOscillator, generatorCheck)
        booster = AKBooster(mixer, gain: 1)
        let panner = AKPanner(booster, pan: currentToneSetting?.pan ?? 0)
        generatorCheck.start()

        AudioKit.output = panner
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
    
}
