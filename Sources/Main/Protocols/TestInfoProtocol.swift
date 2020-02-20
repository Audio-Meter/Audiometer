//
//  TestInfoProtocol.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

protocol TestInfoProtocol: Codable {
    var id: String? { get set }
    var date: Date { get set }
    var patientId: String { get set }
    var comment: String? { get set }
    var result: String? { get }
    var type: Tests { get }
    var presentableDateString: String { get }
}

//extension TestInfoProtocol {
//    func toPatientTest() -> PatientTest {
//        return PatientTest(
//            id: patientId,
//            date: date,
//            type: type,
//            result: result,
//            comment: comment)
//    }
//}

