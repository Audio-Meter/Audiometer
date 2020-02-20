//
//  AKAudioPlayer+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/7/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit

extension AKAudioPlayer {
    func setStarted(_ value: Bool) {
        if isStarted != value {
            if value {
                start()
            } else {
                stop()
            }
        }
    }

    func setPlaying(_ value: Bool) {
        if isPlaying != value {
            if value {
                resume()
            } else {
                pause()
            }
        }
    }

    func setAudioFile(_ value: AKAudioFile) {
        if audioFile.url != value.url {
            try! replace(file: value)
        }
    }
}
