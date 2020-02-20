//
//  TransducerService.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/22/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

class TransducerService {
    func list() -> [Transducer] {
        return [
            "DD45",
            "DD52",
            "TDH-39",
            "TDH-49",
            "HDA 200",
            "HDA 280",
            "HDA 300",
            "B71",
            "B71W",
            "IP30",
            "ER3A",
            "ER5A",
            "ER3C"
        ].map {
            Transducer(name: $0)
        }
    }
}
