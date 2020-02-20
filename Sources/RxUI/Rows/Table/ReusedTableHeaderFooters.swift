//
//  ReusedTableHeaderFooters.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class ReusedTableHeaderFooters<View: UITableViewHeaderFooterView> {
    let table: UITableView
    let identifier: String

    init(table: UITableView, identifier: String) {
        self.table = table
        self.identifier = identifier
    }

    func item(at: IndexPath) -> View {
        return table.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! View
    }
}

extension UITableView {
    func reused<View: UITableViewHeaderFooterView>(headerFooter: View.Type, identifier: String = View.identifier) -> ReusedTableHeaderFooters<View> {
        return ReusedTableHeaderFooters(table: self, identifier: identifier)
    }
}
