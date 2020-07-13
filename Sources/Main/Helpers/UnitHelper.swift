//
//  UnitHelper.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

struct UnitHelper {
    static let max_dBFS: Double = 120 // 24-bit audio

    static func db(fs: Double) -> Double {
        return max_dBFS + 20.0 * log10(fs)
    }

    static func fs(db: Double) -> Double {        
        return max(0.0, pow(10.0, (db - max_dBFS) / 20.0))
    }        
}
