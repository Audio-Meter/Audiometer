//
//  SectionRows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class SectionRows<Item: Equatable>: Rows<Item>, IndexedRows {
    let sections: [[Item]]

    init(_ sections: [[Item]])  {
        self.sections = sections
    }

    override var numberOfSections: Int {
        return sections.count
    }

    override func numberOfItems(inSection section: Int) -> Int {
        return sections[section].count
    }

    override func item(at path: IndexPath) -> Item {
        return sections[path.section][path.row]
    }

    func index(of item: Item) -> IndexPath? {
        for (section, rows) in sections.enumerated() {
            if let row = rows.index(of: item) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
}

extension Array where Element: Equatable {
    func section() -> SectionRows<Element> {
        return SectionRows([self])
    }

    func sections() -> SectionRows<Element> {
        return SectionRows(map { [$0] })
    }
}
