//
//  ReusedTableCells.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class ReusedTableCells<Cell: UITableViewCell> {
    let table: UITableView
    let identifier: String

    init(table: UITableView, identifier: String) {
        self.table = table
        self.identifier = identifier
    }

    func item(at path: IndexPath) -> Cell {
        return table.dequeueReusableCell(withIdentifier: identifier, for: path) as! Cell
    }
}

extension UITableView {
    func reused<Cell: UITableViewCell>(cell: Cell.Type, identifier: String = Cell.identifier) -> ReusedTableCells<Cell> {
        return ReusedTableCells(table: self, identifier: identifier)
    }
}
