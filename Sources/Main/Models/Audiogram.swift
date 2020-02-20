//
//  Audiogram.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/15/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

struct AudiogramKey: Hashable, Codable {
    let conduction: Conduction
    let frequency: Int

    var hashValue: Int {
        return conduction.hashValue + frequency.hashValue
    }

    static func ==(lhs: AudiogramKey, rhs: AudiogramKey) -> Bool {
        return lhs.conduction == rhs.conduction && lhs.frequency == rhs.frequency
    }
}

struct AudiogramValue: Codable {
    let amplitude: Int
    let masked: Bool
    let passed: Bool

    static func passed(amplitude: Int, masked: Bool) -> AudiogramValue {
        return AudiogramValue(amplitude: amplitude, masked: masked, passed: true)
    }
}

struct Audiogram: Codable {
    typealias Key = AudiogramKey
    typealias Value = AudiogramValue
    typealias Entry = (Key,Value)
    typealias Map = [Conduction:[Int:Value]]

    let items: Map
    
    init(_ items: Map) {
        self.items = items
    }

    init() {
        self.init([:])
    }

    func put(_ entry: Entry) -> Audiogram {
        return Audiogram(items.put([entry.0.conduction: [entry.0.frequency: entry.1]]))
    }

    func remove(_ entry: Entry) -> Audiogram {
        return Audiogram(items.delete([entry.0.conduction: [entry.0.frequency: entry.1]]))
    }

    func flatten() -> [Entry] {
        return items.map { item in
            return item.value.map { (Key(conduction: item.key, frequency: $0), $1) }
        }.reduce([], +)
    }
}
