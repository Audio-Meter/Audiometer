//
//  WordTableProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class WordTableProvider: TableProvider, SelectionProvider {
    let sources: Observable<SectionRows<Word>>

    init(table: UITableView, items: Observable<[Word]>) {
        self.sources = items.map { $0.section() }
        super.init(table: table, cells: sources.map { rows in
            return rows.bind(table.reused(cell: WordCell.self))
        })
    }
}
