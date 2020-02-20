//
//  CodeTableProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/15/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class CodeTableProvider: TableProvider {
    //TODO fix to much propertice
    convenience init(table: UITableView, cells: Rows<ReportCodeCellModelProtocol>, report: Report) {
        self.init(table: table, cells: .just(cells), report: report)
    }

    init(table: UITableView, cells: Observable<Rows<ReportCodeCellModelProtocol>>, report: Report) {
        table.registerNib(cell: ReportCodeCell.self)
        //TODO clean code
        super.init(table: table, cells: cells.map { rows in
            rows.bind(table.reused(cell: ReportCodeCell.self), configure: { (item, cell) in
                cell.name.text = item.name
                cell.value.isOn = item.value.value
                item.value.value = item.value.value
                cell.value.isUserInteractionEnabled = !(item.type == .icd9 || item.type == .icd10)
                
                cell.value.rx.controlEvent(UIControlEvents.valueChanged).bind(onNext: { _ in
                    switch item.type{
                    case .cpt:
                        if let index = report.cpt.index(where: {$0.0.fullName == item.name}) {
                            report.cpt.remove(at: index)
                        } else {
                            if let code = MedicalCodeService.cptCodes.first(where: {$0.fullName == item.name}){
                                report.cpt.append((code, true))
                            }
                        }
                        break
                    case .recommendation:
                        if let index = report.recommendationCodes.index(where: {$0.0.fullName == item.name}) {
                            report.recommendationCodes.remove(at: index)
                        } else {
                            if let code = MedicalCodeService.recommendations.first(where: {$0.fullName == item.name}){
                                report.recommendationCodes.append((code, true))
                            }
                        }
                        break
                    default: return
                    }
                })
            })
        })
    }
}

