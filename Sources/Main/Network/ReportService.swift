//
//  ReportService.swift
//  Audiometer
//
//  Created by Bogachov on 25.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation
import Apollo
import RxSwift
import RxSwiftExt
import SafariServices
import os

protocol ReportServiceProtocol {
    func createReport()
}

struct ReportService: ReportServiceProtocol {
    var report = Report()
    let url = PublishSubject<String>()
    let creating = PublishSubject<Bool>()

    func createReport(){
        guard let patientId = report.patient?.id else {
            return
        }
        creating.onNext(true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer
        let storage = Storage(storage: container)
        
        let selectedClinicName = storage.getSelectedClinicName()
        if(!selectedClinicName.isEmpty) {
            let clinicObj = storage.getClinicByName(selectedClinicName)
            let sigData: NSData? = clinicObj?.value(forKey: "logo") as? NSData
            if sigData != nil {
                report.logoBase64 = sigData!.base64EncodedString()
            }
            report.clinic_name = clinicObj?.value(forKey: "name") as? String ?? ""
            report.clinic_address = clinicObj?.value(forKey: "address") as? String ?? ""
            report.clinic_website = clinicObj?.value(forKey: "website") as? String ?? ""
            report.clinic_email = clinicObj?.value(forKey: "email") as? String ?? ""
            report.clinic_tel = clinicObj?.value(forKey: "tel") as? String ?? ""
            report.clinic_fax = clinicObj?.value(forKey: "fax") as? String ?? ""
        }

        let reportInput = report.toReportInput()

        var signs : [SignInput] = []
        for clinicianName in storage.getSelectedClinicians() {
            let clinicianObj = storage.getClinicianByName(clinicianName)
            guard let sigData: NSData = clinicianObj?.value(forKey: "signature") as? NSData else {
                continue
            }
            
            let degrees: String = clinicianObj?.value(forKey: "degrees") as! String
            let certification: String = clinicianObj?.value(forKey: "certification") as! String
            let pcp: Bool = clinicianObj?.value(forKey: "pcp") as! Bool
            
            var input = SignInput()
            input.name = clinicianName
            input.image = sigData.base64EncodedString()
            input.degrees = degrees
            input.pcp = pcp
            input.certification = certification
            signs.append(input)
        }
        
        var rptfiles : [RptfileInput] = []
        for content in report.rptfiles {
            var input = RptfileInput()
            input.content = content
            rptfiles.append(input)
        }
        
        let createReport = CreatePatientReportMutation(
            patient_id: patientId,
            patient_report: reportInput,
            signs: signs,
            rptfiles: rptfiles)
        ApolloClient.sharedClient.perform(mutation: createReport) { (result) in
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.errors != nil && graphQLResult.errors!.count > 0 {
                    return
                } else {
                    self.creating.onNext(false)

                    guard let url = graphQLResult.data?.createReport?.reportUrl else {
                        fatalError("wrong response format")
                    }
                    self.url.onNext(url)
                }
            case .failure(let error):
                os_log("error: %s", error.localizedDescription ?? "no error message")
                return
            }
        }
    }
}

extension Navigator {
    func showSafariViewController(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        guard let navVC = source?.navigationController else { fatalError() }
        navVC.popToRootViewController(animated: false)
        let safariVC = SFSafariViewController(url: url)
        navVC.present(safariVC, animated: true, completion: nil)
    }
}


extension Report {
    //TODO: add tests and other and file
    func toReportInput() -> ReportInput {
        var testsId: [String?] = []
        for test in selectedTests {
            testsId.append(test.id)
        }
        return ReportInput(
            cpt: CodeHelper.cptToString(codes: cpt),
            recommendation: recommendationsToStringArray(codes: recommendationCodes),
            other: other,
            file: file,
            comments: comment.value,
            testIds: testsId,
            logoBase64: logoBase64,
            clinicName: clinic_name,
            clinicAddress: clinic_address,
            clinicTel: clinic_tel,
            clinicFax: clinic_fax,
            clinicEmail: clinic_email,
            clinicWebsite: clinic_website
        )
    }
}
