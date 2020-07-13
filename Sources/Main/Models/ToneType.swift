//
//  ToneType.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/12/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

enum ToneType {
    
    
    case steady, warble(modulation: Double, frequency: Double), pulsed(frequency: Double)

    var typeName:String{
        switch self {
        case .steady: return "s"
        case .warble(modulation: _, frequency: _): return "w"
        case .pulsed(frequency: _): return "p"
        }
    }
    var isPulsed: Bool {
        if case .pulsed(_) = self {
            return true
        } else {
            return false
        }
    }
}
