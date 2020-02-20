//
//  BaseReportPage.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/16/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class BaseReportPage {
    let report: Variable<Report>
    
    init(report: Report) {
        self.report = Variable(report)
    }
    
    func rows(_ list: Variable<[(MedicalCode, Bool)]>) -> Rows<ReportCodeCellModelProtocol> {
        return list.value.map({ (codeTuple) in
            return MedicalCodeAnswer(code: codeTuple.0, answer: codeTuple.1)
        }).section().map { codeAnswer in
            return ReportCodeCellModel(codeAnswer: codeAnswer)
        }
    }
}
