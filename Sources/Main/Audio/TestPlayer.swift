//
//  TestPlayer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/1/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit
import RxSwift
import RxCocoa

protocol TestConfig {
    var isPlayed: Bool { get }
    var dBHL: Int { get }
    
    var calibration: Calibration { get }
    var frequency: Int { get }
    var pan: Double { get }
}

extension TestConfig {
    var amplitude: Double {
        guard isPlayed else {
            return 0
        }
        return fs
    }

    var fs: Double {
        return calibration.fs(frequency: frequency, dBHL: dBHL)
    }
}

