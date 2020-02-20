//
//  Channel.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

enum Channel: Int, Codable {
    case left, right

    var pan: Double {
        switch self {
        case .left:
            return -1
        case .right:
            return 1
        }
    }

    var color: UIColor {
        switch self {
        case .left: return .blue
        case .right: return .red
        }
    }

    var name: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        }
    }

    func applyTo(pan: Double) -> Double {
        if self.pan == pan {
            return pan
        } else if self.pan == -pan {
            return 0
        }
        return -self.pan
    }
}
