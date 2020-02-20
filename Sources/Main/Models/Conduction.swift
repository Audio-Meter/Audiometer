//
//  Conduction.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/15/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

enum Conduction: Hashable, Codable {
    case air(Channel), bone(Channel), soundfield

    static func create(index: Int, channel: Channel) -> Conduction? {
        switch index {
        case 0: return .air(channel)
        case 1: return .bone(channel)
        case 2: return .soundfield
        default: return nil
        }
    }

    func forWord() -> Conduction {
        if case .bone(let channel) = self{
            return .air(channel)
        }
        return self
    }

    var color: UIColor {
        return flatMap { $0.color } ??  #colorLiteral(red: 0.6549019608, green: 0.2352941176, blue: 0.9215686275, alpha: 1)
    }

    var pan: Double {
        return flatMap { $0.pan } ?? 0
    }

    var dashed: Bool {
        switch self {
        case .bone(_):
            return true
        default:
            return false
        }
    }

    func symbol(masked: Bool, pass: Bool) -> String {
        let name = self.name
        if self == .soundfield {
            return name
        }

        let maskedName = masked ? "masked" : "unmasked"
        let passName = pass ? "pass" : "fail"
        return "\(name)_\(maskedName)_\(passName)"
    }

    var name: String {
        switch self {
        case .air(let channel): return "ac_\(channel.name)"
        case .bone(let channel): return "bc_\(channel.name)"
        case .soundfield: return "sf"
        }
    }

    var channel: Channel? {
        return flatMap { $0 }
    }

    func flatMap<T>(body: @escaping (Channel)->T) -> T? {
        switch self {
        case .air(let channel):
            return body(channel)
        case .bone(let channel):
            return body(channel)
        case .soundfield:
            return nil
        }
    }

    var index: Int {
        switch self {
        case .air: return 0
        case .bone: return 1
        case .soundfield: return 2
        }
    }

    var hashValue: Int {
        return index
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodableKeys.self)
        
        if let channel = try? values.decode(Channel.self, forKey: .air) {
            self = .air(channel)
            return
        }
        if let channel = try? values.decode(Channel.self, forKey: .bone) {
            self = .bone(channel)
            return
        }
        if let _ = try? values.decode(Int.self, forKey: .soundfield) {
            self = .soundfield
            return
        }
        throw CodingError.decoding("Decoding Failed. \(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodableKeys.self)
        switch self {
        case let .air(channel):
            try container.encode(channel, forKey: .air)
        case let .bone(channel):
            try container.encode(channel, forKey: .bone)
        case .soundfield:
            try container.encode(Int(0), forKey: .soundfield)
    
        }
    }

    static func ==(lhs: Conduction, rhs: Conduction) -> Bool {
        switch (lhs, rhs) {
        case (.air(let lc), .air(let rc)): return lc == rc
        case (.bone(let lc), .bone(let rc)): return lc == rc
        case (.soundfield, .soundfield): return true
        default: return false
        }
    }
}

extension Conduction {
    enum CodingError: Error { case decoding(String) }
    enum CodableKeys: String, CodingKey { case air, bone, soundfield }
}
