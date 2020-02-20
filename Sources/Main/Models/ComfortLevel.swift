//
//  ComfortLevel.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/21/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

enum ComfortLevel {
    case mcl, ucl
}

extension ComfortLevel: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .mcl
        case 1:
            self = .ucl
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .mcl:
            try container.encode(0, forKey: .rawValue)
        case .ucl:
            try container.encode(1, forKey: .rawValue)
        }
    }
    
}
