//
//  UITableView+Rows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    func register<Cell:UITableViewCell>(cell: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
    }

    func registerNib<Cell:UITableViewCell>(cell: Cell.Type) {
        register(Cell.nib, forCellReuseIdentifier: Cell.identifier)
    }

    func registerNib<View:UITableViewHeaderFooterView>(view: View.Type) {
        register(View.nib, forHeaderFooterViewReuseIdentifier: View.identifier)
    }
}

extension Reactive where Base: UITableView {
    
    var selected: ControlProperty<IndexPath?> {
        return ControlProperty(values: itemSelected.wrap(), valueSink: Binder(base) { table, path in
            table.selectRow(at: path, animated: false, scrollPosition: .none)
        })
    }

    var deselected: ControlProperty<IndexPath?> {
        return ControlProperty(values: itemDeselected.wrap(), valueSink: Binder(base) { table, path in
            if let path = path {
                table.deselectRow(at: path, animated: false)
            }
        })
    }
}
