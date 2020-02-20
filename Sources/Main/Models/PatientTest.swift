//
//  PatientTest.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

struct PatientTest: Identified, Hashable {
    var id: String?
    var date: Date
    let type: Tests
    let result: String?
    var comment: String?

    var hashValue: Int {
        return id!.hashValue
    }
}
