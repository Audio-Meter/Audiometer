//
//  MapRows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class MapRows<Source: RowsType, Item>: Rows<Item> {
    let source: Source
    let transform: (Source.Item)->Item

    init(source: Source, transform: @escaping (Source.Item)->Item) {
        self.source = source
        self.transform = transform
    }

    override var numberOfSections: Int {
        return source.numberOfSections
    }

    override func numberOfItems(inSection section: Int) -> Int {
        return source.numberOfItems(inSection: section)
    }

    override func item(at path: IndexPath) -> Item {
        return transform(source.item(at: path))
    }
}

extension RowsType {
    func map<T>(transform: @escaping (Item)->T) -> MapRows<Self,T> {
        return MapRows(source: self, transform: transform)
    }
}
