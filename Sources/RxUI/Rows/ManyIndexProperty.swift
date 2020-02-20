//
//  ManyIndexProperty.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import RxCocoa

struct ManyIndexProperty<Content: IndexedRows> where Content.Item: Hashable {
    typealias Item = Content.Item
    let selected: IndexProperty<Content>
    let deselected: IndexProperty<Content>

    init(selected: IndexProperty<Content>, deselected: IndexProperty<Content>) {
        self.selected = selected
        self.deselected = deselected
    }

    func write(to selection: Variable<Set<Item>>) -> Disposable {
        return Disposables.create(
            selected.values.unwrap().scan(to: selection) { acc, value in
                var result = acc
                result.insert(value)
                return result
            },
            deselected.values.unwrap().scan(to: selection) { acc, value in
                var result = acc
                result.remove(value)
                return result
            }
        )
    }

    func read(from selection: Variable<Set<Item>>) -> Disposable {
        //TODO
        return Disposables.create()
    }
}

func ||><Content>(property: ManyIndexProperty<Content>, selection: Variable<Set<Content.Item>>) -> Disposable {
    return property.write(to: selection)
}
