//
//  MaskingType.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/13/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit

enum MaskingType: Int {
    case wn, nbn, pn, sn

    var name: String {
        switch self {
        case .wn: return "wn"
        case .nbn: return "nbn"
        case .pn: return "pn"
        case .sn: return "sn"
        }
    }
    
    static var allText:[String] = [MaskingType.wn.name.uppercased(),MaskingType.nbn.name.uppercased(),MaskingType.pn.name.uppercased(),MaskingType.sn.name.uppercased()]

    func file(frequency: Int) -> AKAudioFile {
        return try! AKAudioFile(readFileName: fileName(frequency: frequency))
    }

    func fileName(frequency: Int) -> String {
        if self == .nbn {
            return "NBN-\(frequency)Hz.wav"
        } else {
            return "\(name.uppercased()).caf"
        }
    }
}
