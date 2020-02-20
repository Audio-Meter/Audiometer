//
//  Rows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

protocol IndexedType {
    associatedtype Item
    func item(at: IndexPath) -> Item
}

protocol RowsType: RowSource, IndexedType {
}

protocol IndexedRows: RowsType {
    func index(of item: Item) -> IndexPath?
}

class Rows<Item>: RowsType {
    var numberOfSections: Int {
        fatalError()
    }

    func numberOfItems(inSection: Int) -> Int {
        fatalError()
    }

    func item(at: IndexPath) -> Item {
        fatalError()
    }
}
