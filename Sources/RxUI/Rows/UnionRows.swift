//
//  UnionRows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/3/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class SectionUnionRows<Item>: Rows<Item> {
    let left: Rows<Item>
    let right: Rows<Item>

    init(left: Rows<Item>, right: Rows<Item>) {
        self.left = left
        self.right = right
    }

    override var numberOfSections: Int {
        return left.numberOfSections + right.numberOfSections
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        let leftCount = left.numberOfSections
        if section < leftCount {
            return left.numberOfItems(inSection: section)
        } else {
            return right.numberOfItems(inSection: section - leftCount)
        }
    }

    override func item(at path: IndexPath) -> Item {
        let leftCount = left.numberOfSections
        if path.section < leftCount {
            return left.item(at: path)
        } else {
            let rightPath = IndexPath(row: path.row, section: path.section - leftCount)
            return right.item(at: rightPath)
        }
    }
}

class RowUnionRows<Item>: Rows<Item> {
    let left: Rows<Item>
    let right: Rows<Item>
    
    init(left: Rows<Item>, right: Rows<Item>) {
        self.left = left
        self.right = right
    }
    
    override var numberOfSections: Int {
        return left.numberOfSections
    }

    override func numberOfItems(inSection section: Int) -> Int {
        return left.numberOfItems(inSection: section) + right.numberOfItems(inSection: section)
    }

    override func item(at path: IndexPath) -> Item {
        let leftCount = left.numberOfItems(inSection: path.section)
        if path.row < leftCount {
            return left.item(at: path)
        } else {
            let rightPath = IndexPath(row: path.row - leftCount, section: path.section)
            return right.item(at: rightPath)
        }
    }
}

enum RowUnionType {
    case sections, rows
}

extension Rows {
    func append(_ type: RowUnionType, _ rows: Rows<Item>) -> Rows<Item> {
        switch type {
        case .sections: return SectionUnionRows(left: self, right: rows)
        case .rows: return RowUnionRows(left: self, right: rows)
        }
    }
}
