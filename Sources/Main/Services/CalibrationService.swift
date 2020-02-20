//
//  CalibrationService.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

class CalibrationService {
    func load(transducer: Transducer, type: CalibrationType, pan: Double) -> Calibration {
        guard let values = UserDefaults.standard.object(forKey: getKey(transducer: transducer, type: type, pan: pan)) as? [String: NSNumber] else {
            return Calibration(values: [
                125: 0.33,
                250: 0.1388828745807199,
                500: 0.03069873201064617,
                750: 0.02,
                1000: 0.01792265431989521,
                1500: 0.018,
                2000: 0.01972995891992637,
                3000: 0.01078466794595396,
                4000: 0.02583155638257576,
                6000: 0.04609494424811695,
                8000: 0.05
                ])
        }
        
        var newDict = [Int: Double]()
        values.forEach { newDict[Int($0.key)!] = Double(truncating: $0.value) }
        return Calibration(values: newDict)
    }

    func save(transducer: Transducer, type: CalibrationType, pan: Double, calibration: Calibration) {
        var newDict = [String: NSNumber]()
        calibration.values.forEach { newDict[String($0.key)] = NSNumber(value: $0.value) }
        UserDefaults.standard.set(newDict, forKey: getKey(transducer: transducer, type: type, pan: pan))
    }
    
    private func getKey(transducer: Transducer, type: CalibrationType, pan: Double) -> String {
        let key = "\(transducer.name)-\(type)-\(pan)"
        return key
    }
}
