//
//  MedicalCode.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/13/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

struct MedicalCode: Equatable {
    
    enum Table: Int {
        case cpt
        case icd10
        case fda
        case recommendation
        case other
        case icd9
    }

    let id: Int
    let table: Table
    let title: String
    let description: String?
    
    var fullName: String {
        if let description = description, !description.isEmpty {
            return "\(title) - \(description)"
        }
        return title
    }
    

    
    init(id: Int, table: Table, title: String, description: String? = nil) {
        self.id = id
        self.table = table
        self.title = title
        self.description = description
    }

    static func ==(lhs: MedicalCode, rhs: MedicalCode) -> Bool {
        return lhs.title == rhs.title
    }
}

// TODO: Use MedicalCodeAnswer instead of (MedicalCode, Bool) Tuple
struct MedicalCodeAnswer : Equatable {
    let code: MedicalCode
    let answer: Bool
    
    static func ==(lhs: MedicalCodeAnswer, rhs: MedicalCodeAnswer) -> Bool {
        return lhs.code == rhs.code && lhs.answer == rhs.answer
    }
}
