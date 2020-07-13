//
//  Channel.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

enum Channel: Int, Codable {
    case left, right, binaural

    var pan: Double {
        switch self {
        case .left:
            return -1
        case .right:
            return 1
        case .binaural : return 0
        }
    }

    var color: UIColor {
        switch self {
        case .left: return .blue
        case .right: return .red
        case .binaural : return .white
        }
    }

    var name: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .binaural: return "binaural"
        }
    }

    func applyTo(pan: Double) -> Double {
        return self.pan
    }
}
