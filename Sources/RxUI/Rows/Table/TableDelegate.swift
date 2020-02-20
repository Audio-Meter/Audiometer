//
//  TableDelegate.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class TableDelegate: NSObject, UITableViewDelegate {
    var headers: TableHeaderFooters?
    var footers: TableHeaderFooters?

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headers?.item(at: IndexPath(row: 0, section: section))
    }
}
