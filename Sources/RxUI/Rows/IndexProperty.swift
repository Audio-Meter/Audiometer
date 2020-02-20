//
//  IndexProperty.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct IndexProperty<Content: RowsType>: ObservableConvertibleType  {
    typealias Item = Content.Item
    let index: ControlProperty<IndexPath?>
    let content: Observable<Content>

    var values: Observable<Item?> {
        return content.map { rows in
            self.index.map { path in
                guard let path = path else {
                    return nil
                }
                return rows.item(at: path)
            }
        }.switchLatest()
    }

    func asObservable() -> Observable<Item?> {
        return values
    }
}

extension IndexProperty where Content: IndexedRows {
    func index(of items: Observable<Item?>) -> Observable<IndexPath?> {
        let shared = items.share(replay: 1, scope: .forever)
        return content.map { rows in
            return shared.map { item in
                guard let item = item else {
                    return nil
                }
                return rows.index(of: item)
            }
        }.switchLatest()
    }
}

func ||><Content>(items: Observable<Content.Item?>, property: IndexProperty<Content>) -> Disposable where Content: IndexedRows {
    return property.index(of: items).subscribe(property.index)
}

func ||><Content>(items: Observable<Content.Item>, property: IndexProperty<Content>) -> Disposable where Content: IndexedRows {
    return items.wrap() ||> property
}

func <||><Content>(property: IndexProperty<Content>, items: Variable<Content.Item?>) -> Disposable where Content: IndexedRows {
    return Disposables.create(
        property.asObservable() ||> items,
        items.asObservable() ||> property
    )
}

func <||><Content>(property: IndexProperty<Content>, items: Variable<Content.Item>) -> Disposable where Content: IndexedRows {
    return Disposables.create(
        property.asObservable().filterNil() ||> items,
        items.asObservable() ||> property
    )
}
