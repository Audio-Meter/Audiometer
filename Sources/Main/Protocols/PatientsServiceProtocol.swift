//
//  PatientsService.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

protocol PatientShortInfoProtocol {
    var lastName: String? { get set }
    var firstName: String? { get set }
}

protocol PatientInfo: PatientShortInfoProtocol {
    var id: String? { get set }
    var genderValue: Genders { get set }
    var email: String? { get set }
    var mailingAddress_1: String? { get set }
    var mailingAddress_2: String? { get set }
    var city: String? { get set }
    var state: String? { get set }
    var zip: String? { get set }
    var phoneNumber: String? { get set }
    var dateOfBirth: Date? { get set }
    var socialSecurityNumber: String? { get set }
    var insurance: String? { get set }
    var patientId: String? { get set }
    var icd_9: [(MedicalCode, Bool)] { get set}
    var icd_10: [(MedicalCode, Bool)] { get set}
}

extension PatientInfo {
    var fullName: String {
        let fName = firstName ?? ""
        let lName = lastName ?? ""
        if fName.isEmpty {
            return lName
        }
        if lName.isEmpty {
            return fName
        }
        return fName + " " + lName
    }
    
    mutating func update(info: PatientInfo) {
        email = info.email
        mailingAddress_1 = info.mailingAddress_1
        mailingAddress_2 = info.mailingAddress_2
        city = info.city
        state = info.state
        zip = info.zip
        phoneNumber = info.phoneNumber
        dateOfBirth = info.dateOfBirth
        firstName = info.firstName
        lastName = info.lastName
        genderValue = info.genderValue
        socialSecurityNumber = info.socialSecurityNumber
        insurance = info.insurance
        patientId = info.patientId
    }
    
    var dateOfBirthStringServerRepresentation: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let db = dateOfBirth else {
            return ""
        }
        return dateFormatter.string(from: db)
    }
}

func dateOfBirthFrom(stringServerRepresentation: String?) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: stringServerRepresentation ?? "")
}

protocol PatientsServiceProtocol {
    func fetchPatients(completion: @escaping ([PatientInfo], Error?) -> Void)
    func createNewPatient(info: PatientInfo, completion: @escaping (Error?) -> Void)
    func editPatient(info: PatientInfo, completion: @escaping (Error?) -> Void)
    func deletePatient(id: String, completion: @escaping (Error?) -> Void)
}
