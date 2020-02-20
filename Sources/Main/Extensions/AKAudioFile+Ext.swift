//
//  AKAudioFile+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/12/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit

extension AKAudioFile {
    static var empty: AKAudioFile {
        return try! AKAudioFile(readFileName: "empty.caf")
    }

    func play(in player: AKAudioPlayer) {
        player.setAudioFile(self)
    }
}
