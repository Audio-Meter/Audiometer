//
//  PatientPage.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxSwiftExt
import os

class PatientPage: DetailsItemsCellsProtocol {
    let disposeBag = DisposeBag()
    let service: PatientsServiceProtocol
    var didAddNewPatient = Variable(false)
    var didUpdatePatient: Variable<PatientInfo?> = Variable(nil)
    var didDeletePatient = Variable(false)
    
    private var patientDetails: PatientInfo? {
        didSet {
            id.value = patientDetails?.id ?? ""
            firstName.value = patientDetails?.firstName ?? ""
            lastName.value = patientDetails?.lastName ?? ""
            gender.value = patientDetails?.genderValue ?? Genders.m
            mailingAddress1.value = patientDetails?.mailingAddress_1 ?? ""
            mailingAddress2.value = patientDetails?.mailingAddress_2 ?? ""
            city.value = patientDetails?.city ?? ""
            state.value = patientDetails?.state ?? ""
            zip.value = patientDetails?.zip ?? ""
            phoneNUmber.value = patientDetails?.phoneNumber ?? ""
            dateOfBirth.value = patientDetails?.dateOfBirth
            email.value = patientDetails?.email ?? ""
            insurance.value = patientDetails?.insurance ?? ""
            socialSecurityNumber.value = patientDetails?.socialSecurityNumber ?? ""
            patientId.value = patientDetails?.patientId ?? ""
            icd_9.value = patientDetails?.icd_9 ?? []
            icd_10.value = patientDetails?.icd_10 ?? []
        }
    }
    
    var hasAnyPatientDetails: Bool {
        guard patientDetails != nil else {
            return dateOfBirth.value != nil ||
            firstName.value.isEmpty == false ||
            lastName.value.isEmpty == false ||
            email.value.isEmpty == false ||
            mailingAddress1.value.isEmpty == false ||
            mailingAddress2.value.isEmpty == false ||
            city.value.isEmpty == false ||
            state.value.isEmpty == false ||
            zip.value.isEmpty == false ||
            phoneNUmber.value.isEmpty == false
        }
        return true
    }
    
    func isEqualTo(patient: PatientInfo) -> Bool {
        guard let patientDetails = self.patientDetails else {
            return false
        }
        return patient.id == patientDetails.id
    }
    
    func delete() {
        guard let patientDetails = self.patientDetails else {
            return
        }
        
        guard let id = patientDetails.id.value else {
            return
        }
//        os_log("Patient id: %s. ", id)
        
        service.deletePatient(id: id) { (err) in
            // Debug error messages
            self.didDeletePatient.value = (err == nil)
        }
    }
    
    var id: Variable = Variable("")
    var dateOfBirth: Variable<Date?> = Variable(nil)
    var firstName = Variable("")
    var lastName = Variable("")
    var gender = Variable(Genders.m)
    var email = Variable("")
    var mailingAddress1 = Variable("")
    var mailingAddress2 = Variable("")
    var city = Variable("")
    var state = Variable("")
    var zip = Variable("")
    var phoneNUmber = Variable("")
    var lastError = Variable<Error?>(nil)
    var loading = Variable(false)
    var socialSecurityNumber = Variable("")
    var insurance = Variable("")
    var patientId: Variable = Variable("")
    var tests: Variable<[PatientTest]> = Variable([])
    var icd_9:  Variable<[(MedicalCode, Bool)]> = Variable([])
    var icd_10:  Variable<[(MedicalCode, Bool)]> = Variable([])
    
    func items() -> [DetailItemCellProtocol] {
        return [
            DetailsCellStringItem(variable: firstName, description: "First Name", format: .wordCap),
            DetailsCellStringItem(variable: lastName, description: "Last Name", format: .wordCap),
            DetailsCellDateItem(variable: dateOfBirth, description: "Date of Birth"),
            DetailsCellSegmentedItem(selectedIndex: gender, description: "Gender", type: .segmentControl, segmentTitles: ["Male", "Female"]),
            DetailsCellStringItem(variable: email, description: "Email ID"),
            DetailsCellStringItem(variable: mailingAddress1, description: "Mailing Address 1"),
            DetailsCellStringItem(variable: mailingAddress2, description: "Mailing Address 2"),
            DetailsCellStringItem(variable: city, description: "City", format: .wordCap),
            DetailsCellStringItem(variable: state, description: "State/province", format: .allCap),
            DetailsCellStringItem(variable: zip, description: "Zip/post code"),
            DetailsCellStringItem(variable: phoneNUmber, description: "Phone"),
            DetailsCellStringItem(variable: patientId, description: "Authorization#"),
            DetailsCellStringItem(variable: socialSecurityNumber, description: "SS#: XXX-XX-", format: .hyphen("xxx-xx-xxxx")),
            DetailsCellStringItem(variable: insurance, description: "Insurance#")
            
        ]
    }
    
    init(patientDetails: PatientInfo? = nil, service: PatientsServiceProtocol = PatientsService()) {
        self.patientDetails = patientDetails
        self.service = service
    }
    
    func set(patientDetails: PatientInfo?) {
        self.patientDetails = patientDetails
    }
    
    func save() {
        let currentGender = self.gender.value
        let info = Patient(
            id: id.value,
            genderValue: currentGender,
            email: email.value,
            mailingAddress_1: mailingAddress1.value,
            mailingAddress_2: mailingAddress2.value,
            city: city.value,
            state: state.value,
            zip: zip.value,
            phoneNumber: phoneNUmber.value,
            dateOfBirth: dateOfBirth.value,
            lastName: lastName.value,
            firstName: firstName.value,
            socialSecurityNumber: socialSecurityNumber.value,
            insurance: insurance.value,
            patientId: patientId.value,
            icd_9: icd_9.value,
            icd_10: icd_10.value)
        loading.value = true
        if patientDetails != nil, info.id != ""{
            service.editPatient(info: info, completion: { [weak self] (requestError) in
                self?.loading.value = false
                guard requestError == nil else {
                    self?.lastError.value = requestError
                    return
                }
                self?.patientDetails?.update(info: info)
                self?.didUpdatePatient.value = info
            })
            return
        }
        service.createNewPatient(info: info) { [weak self] (requestError) in
            self?.loading.value = false
            guard requestError == nil else {
                self?.lastError.value = requestError
                return
            }
            self?.patientDetails = info
            self?.didAddNewPatient.value = true
        }
    }
}
