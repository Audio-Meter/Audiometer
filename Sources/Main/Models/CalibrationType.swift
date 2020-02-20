//
//  CalibrationType.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

enum CalibrationType {
    case tone, word, masking(MaskingType)
    
    var typeName:String{
        switch self {
        case .tone: return "Pure Tone"
        case .word: return "Speech"
        default: return ""
        }
    }
    
    static var allText:[String] = [CalibrationType.tone.typeName, CalibrationType.word.typeName]
}
