//
//  BindTableRows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class BindTableRows<Items: RowsType, Cell: UITableViewCell>: TableCells {
    typealias Cells = ReusedTableCells<Cell>
    let items: Items
    let cells: Cells
    let configure: (Items.Item, Cell)->Void

    init(items: Items, cells: Cells, configure: @escaping (Items.Item, Cell)->Void) {
        self.items = items
        self.cells = cells
        self.configure = configure
    }

    override var numberOfSections: Int {
        return items.numberOfSections
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        return items.numberOfItems(inSection: section)
    }
    
    override func item(at path: IndexPath) -> UITableViewCell {
        let item = items.item(at: path)
        let cell = cells.item(at: path)
        configure(item, cell)
        return cell
    }
}

extension RowsType {
    func bind<Cell>(_ cells: ReusedTableCells<Cell>) -> TableCells where Cell: Bindable, Item == Cell.Model {
        return bind(cells) { item, cell in
            cell.bind(model: item)
        }
    }

    func bind<Cell>(_ cells: ReusedTableCells<Cell>, configure: @escaping (Item, Cell)->Void) -> TableCells {
        return BindTableRows(items: self, cells: cells, configure: configure)
    }
}
