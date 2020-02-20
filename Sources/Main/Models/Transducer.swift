//
//  Transducer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

struct Transducer: Equatable {
    let name: String

    static func ==(lhs: Transducer, rhs: Transducer) -> Bool {
        return lhs.name == rhs.name
    }
}
