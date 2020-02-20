//
//  BindTableHeaderFooterRows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class BindTableHeaderFooterRows<Items: RowsType, View: UITableViewHeaderFooterView>: TableHeaderFooters {
    typealias Views = ReusedTableHeaderFooters<View>
    let items: Items
    let views: Views
    let configure: (Items.Item, View)->Void

    init(items: Items, views: Views, configure: @escaping (Items.Item, View)->Void) {
        self.items = items
        self.views = views
        self.configure = configure
    }

    override func item(at path: IndexPath) -> UITableViewHeaderFooterView {
        let item = items.item(at: IndexPath(row: path.section, section: 0))
        let view = views.item(at: path)
        configure(item, view)
        return view
    }
}

extension RowsType {
    func bind<View>(_ views: ReusedTableHeaderFooters<View>) -> TableHeaderFooters where View: Bindable, Item == View.Model {
        return bind(views) { item, view in
            view.bind(model: item)
        }
    }

    func bind<View>(_ views: ReusedTableHeaderFooters<View>, configure: @escaping (Item, View)->Void) -> TableHeaderFooters {
        return BindTableHeaderFooterRows(items: self, views: views, configure: configure)
    }
}
