//
//  PatientTestTableProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class PatientTestTableProvider: TableProvider, SelectionProvider {
    let sources: Observable<SectionRows<PatientTest>>

    init(table: UITableView, tests: [PatientTest]) {
        table.registerNib(cell: PatientTestCell.self)
        table.registerNib(view: PatientTestHeader.self)

        let groups = tests.group(by: { $0.type })
        let sources = SectionRows(groups)
        self.sources = .just(sources)
        
        let cells = sources.bind(table.reused(cell: PatientTestCell.self))
        
        
        let headers = groups.map { PatientTestHeaderModel(rows: $0) }.section()
            .bind(table.reused(headerFooter: PatientTestHeader.self))
        super.init(table: table, cells: cells, headers: headers)
    }
}
