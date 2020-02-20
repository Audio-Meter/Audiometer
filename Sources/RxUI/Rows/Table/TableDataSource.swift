//
//  TableDataSource.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class TableDataSource: NSObject, UITableViewDataSource {
    let table: UITableView

    var cells: TableCells? {
        didSet {
            table.reloadData()
        }
    }

    init(table: UITableView) {
        self.table = table
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return cells?.numberOfSections ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells!.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells!.item(at: indexPath)
    }
}

func ||>(data: Observable<TableCells>, dataSource: TableDataSource) -> Disposable {
    return data.subscribe(onNext: {
        dataSource.cells = $0
    })
}
