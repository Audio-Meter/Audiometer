//
//  Report.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/13/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
//TODO: clear fildes
class Report {
    var fda: [(MedicalCode, Bool)] = []
    var cpt: [(MedicalCode, Bool)] = []
    var other: String = ""
    var recommendationCodes: [(MedicalCode, Bool)] = []
    var recommendationText: String = ""
    var comment: Variable<String> = Variable("")
    var referral: UIImage?
    var tests: [PatientTest] = []
    var selectedTests: [PatientTest] = []
    var file: String? 
    var patient: PatientInfo?
    var logoBase64: String = ""
    var clinic_name: String = ""
    var clinic_address: String = ""
    var clinic_website: String = ""
    var clinic_tel: String = ""
    var clinic_fax: String = ""
    var clinic_email: String = ""
    var rptfiles: [String] = []

    func answerForCode(code: MedicalCode) -> Bool? {
        var correctArray: [(MedicalCode, Bool)]?
        switch code.table {
        case .icd9:
            correctArray = patient?.icd_9
        case .icd10:
            correctArray = patient?.icd_10
        default:
            fatalError("unexpected table \(code.table)")
        }
        
        return correctArray?.first(where: { $0.0 == code})?.1
    }
    
    func setAnswerForCode(code: MedicalCode, answer: Bool?) {
        func setAnswer(correctArray: inout [(MedicalCode, Bool)]) {
            var index = 0
            if let i = correctArray.index(where: { $0.0 == code}) {
                correctArray.remove(at: i)
                index = i
            }
            
            if let answer = answer {
                correctArray.insert((code, answer), at: index)
            }
        }
        
        guard var patient = patient else {
            return
        }
        
        switch code.table {
        case .icd9:
            let fallbackArray = patient.icd_9
            setAnswer(correctArray: &patient.icd_9)
            self.patient = patient
            PatientsService().editPatient(info: patient) { (error) in
                if error != nil {
                    patient.icd_9 = fallbackArray
                }
            }
        case .icd10:
            let fallbackArray = patient.icd_10
            setAnswer(correctArray: &patient.icd_10)
            self.patient = patient
            PatientsService().editPatient(info: patient) { (error) in
                if error != nil {
                    patient.icd_10 = fallbackArray
                }
            }
        default:
            fatalError("unexpected table \(code.table)")
        }
    }
}

extension Report {
    func recommendationsToStringArray(codes: [(MedicalCode, Bool)]) -> [String] {
        var codeArray: [String] = []
        for code in codes{
            codeArray.append(code.0.title)
        }
        return codeArray
    }
}
