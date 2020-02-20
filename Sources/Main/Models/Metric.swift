//
//  Metric.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/1/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct Metric {
    static let mainFreqs = [125, 250, 500, 1000, 2000, 4000, 8000]
    static let auxFreqs = [750, 1500, 3000, 6000]
    static let frequencies = (mainFreqs + auxFreqs).sorted()

    static let amplitudes = Array(stride(from: -10, to: 125, by: 5))
    static let mainAmps = Array(stride(from: -10, to: 130, by: 10))

    static let percentFreqs = [7.5, 15, 30, 40, 7.5]

    static func indexOf(freq: Int) -> CGFloat {
        return indexOf(value: freq, from: mainFreqs)
    }

    static func indexOf(amp: Int) -> CGFloat {
        return indexOf(value: amp, from: mainAmps)
    }

    private static func indexOf(value: Int, from list: [Int]) -> CGFloat {
        guard let index = (list.index { $0 >= value }) else {
            return CGFloat(list.count - 1)
        }
        if index == 0 {
            return 0
        }
        let low = list[index - 1]
        let high = list[index]
        return CGFloat(index - 1) + CGFloat(value - low) / CGFloat(high - low)
    }
}

