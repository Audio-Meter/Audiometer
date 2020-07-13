//
//  Calibration.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

struct Calibration {
    let values: [Int:Double]

    static var zero: Calibration {
        let values = Metric.frequencies.map { ($0, Double(0)) }
        return Calibration(values: Dictionary(uniqueKeysWithValues: values))
    }

    func append(frequency: Int, value: Double) -> Calibration {
        let fs = get(frequency)
        let db = UnitHelper.db(fs: fs) + value
        return put(frequency, UnitHelper.fs(db: db))
    }

    func get(_ frequency: Int) -> Double {
        return values[frequency] ?? 0
    }

    func put(_ frequency: Int, _ fs: Double) -> Calibration {
        return Calibration(values: values.put([frequency:fs]))
    }

    func fs(frequency: Int, dBHL: Int) -> Double {
        let fs = get(frequency)
        if AgoraRtm.rtmChannel == nil{
            let dBFS = UnitHelper.db(fs: fs) + Double(dBHL) - 70
            return UnitHelper.fs(db: dBFS)
        }else{
            let dBFS = UnitHelper.db(fs: fs) + Double(dBHL) - 70
            return UnitHelper.fs(db: dBFS)
        }        
    }
}
