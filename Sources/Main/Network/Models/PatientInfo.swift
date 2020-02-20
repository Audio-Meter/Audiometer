//
//  PatientInfo.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

struct Patient: PatientInfo {
    var id: String?
    var genderValue: Genders
    var email: String?
    var mailingAddress_1: String?
    var mailingAddress_2: String?
    var city: String?
    var state: String?
    var zip: String?
    var phoneNumber: String?
    var dateOfBirth: Date?
    var lastName: String?
    var firstName: String?
    var socialSecurityNumber: String?
    var insurance: String?
    var patientId: String?
    var icd_9:  [(MedicalCode, Bool)]
    var icd_10:  [(MedicalCode, Bool)]

}
