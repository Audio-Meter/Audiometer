//
//  PatientTestHeaderModel.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

struct PatientTestHeaderModel: Equatable {
    let rows: [PatientTest]

    var name: String {
        if (rows[0].type == .speech) {
            return "Speech Tests (\(rows.count))"
        } else if (rows[0].type == .tone) {
             return "Tone Tests (\(rows.count))"  
        }
        else {
            return "\(rows[0].type.title) (\(rows.count))"
        }
    }
    
    static func ==(lhs: PatientTestHeaderModel, rhs: PatientTestHeaderModel) -> Bool {
        return false
    }
}
