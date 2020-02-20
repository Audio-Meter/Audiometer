//
//  Report2Page.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/16/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class Report2Page: BaseReportPage {
    let comment: Variable<String>
    //TOD: clean code
    var selectedTests = Variable(Set<PatientTest>()) {
        didSet {
            report.value.selectedTests  = Array(selectedTests.value)
        }
    }
    let signature: Variable<UIImage?>
    var isSignatureEdit = false 
    private let otherVar: Variable<String>

    override init(report: Report) {
        comment = report.comment
        otherVar = Variable(report.other)
        report.other = report.recommendationText
        guard let user = User.current else {
            fatalError()
        }
        signature = user.signature
        selectedTests.asObservable().subscribe({ (value) in
            guard let newSelected = value.element else {
                return
            }
            report.selectedTests = Array(newSelected)
        })
        
        super.init(report: report)
    }

    //TODO: remove other row
    var otherRows: Rows<ReportCodeCellModelProtocol> {
        return rows(Variable([]))
    }

    var tests: [PatientTest] {
        return self.report.value.tests
//        let service = TestService()
//        return service.all().sorted(by: { $0.type.rawValue < $1.type.rawValue })
    }

    func store() -> Report {
        let report = self.report.value
        report.comment = comment
        report.other = otherVar.value
        return report
    }
}
