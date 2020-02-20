//
//  PatientService.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import Apollo
import os

struct PatientsService: PatientsServiceProtocol {
    
    func createNewPatient(info: PatientInfo, completion: @escaping (Error?) -> Void) {
        let patientItem = info.toPatientItem()
        let createPatient = CreatePatientMutation(patient: patientItem)
        ApolloClient.sharedClient.perform(mutation: createPatient) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(graphQLResult.errors!.first)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error)
            }
            
        }
    }
    
    func editPatient(info: PatientInfo, completion: @escaping (Error?) -> Void) {
        let patientItem = info.toPatientItem()
        let update = UpdatePatientMutation(id: info.id ?? "", patient: patientItem)
        ApolloClient.sharedClient.perform(mutation: update) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(graphQLResult.errors!.first)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func deletePatient(id: String, completion: @escaping (Error?) -> Void) {
        let del = DeletePatientMutation(id: id)
        ApolloClient.sharedClient.perform(mutation: del) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion(graphQLResult.errors!.first)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func fetchPatients(completion: @escaping ([PatientInfo], Error?) -> Void) {
        let patientQuery = PatientsQuery()
        ApolloClient.sharedClient.fetch(query: patientQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    completion([], graphQLResult.errors!.first)
                } else {
                    let res = graphQLResult.data?.patients?.flatMap { (item) -> Patient in
                        let dateOfBirth = dateOfBirthFrom(stringServerRepresentation: item?.fragments.patientDetails.dateOfBirth)
                        let patinentInfo = Patient(
                            id: item?.fragments.patientDetails.id,
                            genderValue: item?.fragments.patientDetails.gender ?? .m,
                            email: item?.fragments.patientDetails.email,
                            mailingAddress_1: item?.fragments.patientDetails.mailingAddress_1,
                            mailingAddress_2: item?.fragments.patientDetails.mailingAddress_2,
                            city: item?.fragments.patientDetails.city,
                            state: item?.fragments.patientDetails.state,
                            zip: item?.fragments.patientDetails.zip,
                            phoneNumber: item?.fragments.patientDetails.phoneNumber,
                            dateOfBirth: dateOfBirth,
                            lastName: item?.fragments.patientDetails.lastName,
                            firstName: item?.fragments.patientDetails.firstName,
                            socialSecurityNumber: item?.fragments.patientDetails.ssn,
                            insurance: item?.fragments.patientDetails.insurance,
                            patientId: item?.fragments.patientDetails.patientId,
                            icd_9: CodeHelper.stringToCode(string: item?.fragments.patientDetails.icd_9, codes: MedicalCodeService.icd9codes),
                            icd_10: CodeHelper.stringToCode(string: item?.fragments.patientDetails.icd_10, codes: MedicalCodeService.icd10codes))
                        return patinentInfo
                    }
                    if res != nil {
                        completion(res!, nil)
                    }
                }
            case .failure(let error):
                completion([], error)
            }
        }
    }
}

extension PatientInfo {
    func toPatientItem() -> PatientInput {
        return PatientInput(
            dateOfBirth: dateOfBirthStringServerRepresentation,
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            gender: genderValue,
            mailingAddress_1: mailingAddress_1,
            mailingAddress_2: mailingAddress_2,
            city: city,
            state: state,
            phoneNumber: phoneNumber,
            zip: zip,
            email: email ?? "",
            ssn: socialSecurityNumber ?? "",
            insurance: insurance ?? "",
            patientId: patientId ?? "",
            icd_9: CodeHelper.codeToString(codes: icd_9),
            icd_10: CodeHelper.codeToString(codes: icd_10))
        
    }
}
