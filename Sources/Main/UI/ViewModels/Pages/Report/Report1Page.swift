//
//  Report1Page.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/14/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class Report1Page: BaseReportPage {
    let complaintType = Variable(MedicalCode.Table.cpt)
    private let complaintVars: [MedicalCode.Table:Variable<[(MedicalCode, Bool)]>]
   // private let proceduresVar: Variable<[Code]>
    private let recommendationsVar: Variable<[(MedicalCode, Bool)]>
    let recommendationText: Variable<String>
    let referral = Variable<UIImage?>(nil)
    let file = Variable<String?>(nil)
//    let files = Variable<[String]>([])

    override init(report: Report) {
        complaintVars = [
            //.fda: Variable(report.fda),
            .icd9: Variable(report.patient!.icd_9),
            .icd10: Variable(report.patient!.icd_10),
            .cpt: Variable(MedicalCodeService.cptCodesEmptyList)
        ]
        //proceduresVar = Variable(report.procedures)
        recommendationsVar = Variable(MedicalCodeService.recommendationEmptyList)
        recommendationText = Variable(report.recommendationText)

        super.init(report: report)
    }

    var complaintRows: Observable<Rows<ReportCodeCellModelProtocol>> {
        return complaintType.asObservable().map { type in
            return self.icdRows(self.complaintVars[type]!)
        }
    }
    
    func icdRows(_ list: Variable<[(MedicalCode, Bool)]>) -> Rows<ReportCodeCellModelProtocol> {
        return list.value.map({ (codeTuple) in
            return MedicalCodeAnswer(code: codeTuple.0, answer: codeTuple.1)
        }).section().map { (codeAnswer) in
            return ReportCodeCellModel(codeAnswer: codeAnswer)
        }
    }

//    var procedureRows: Rows<ReportCodeCellModelProtocol> {
//        return rows(proceduresVar)
//    }

    var recommendationRows: Rows<ReportCodeCellModelProtocol> {
        return rows(recommendationsVar)
    }

    func store() -> Report {
        let report = self.report.value
//        report.fda = complaintVars[.fda]!.value
        report.patient?.icd_9 = complaintVars[.icd9]!.value
        report.patient?.icd_10 = complaintVars[.icd10]!.value
//        report.procedures = proceduresVar.value
        report.recommendationText = recommendationText.value
        report.referral = referral.value
        report.file = file.value
        return report
    }

    func store(pages: Observable<Report2Page>) -> Observable<Report> {
        return pages.map { $0.report.updates }.switchLatest()
    }
    
    func nextPage(taps: Observable<Void>) -> Observable<Report2Page> {
        return taps.withLatestFrom(report.asObservable()).map {
            Report2Page(report: $0)
        }.share()
    }
}
