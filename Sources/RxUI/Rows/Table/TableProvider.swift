//
//  TableProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class TableProvider {
    let table: UITableView
    let cells: Observable<TableCells>
    let headers: Observable<TableHeaderFooters>?

    init(table: UITableView, cells: TableCells, headers: TableHeaderFooters? = nil) {
        self.table = table
        self.cells = .just(cells)
        self.headers = headers.flatMap { .just($0) }
    }

    init(table: UITableView, cells: Observable<TableCells>, headers: Observable<TableHeaderFooters>? = nil) {
        self.table = table
        self.cells = cells
        self.headers = headers
    }

    func bind() -> Disposable {
        return Disposables.create(
            cells ||> dataSource,
            headers.trySubscribe(onNext: {
                self.delegate.headers = $0
            })
        )
    }

    lazy var dataSource: TableDataSource = {
        let dataSource = TableDataSource(table: table)
        table.dataSource = dataSource
        return dataSource
    }()

    lazy var delegate: TableDelegate = {
        let delegate = TableDelegate()
        table.delegate = delegate
        return delegate
    }()
}

extension Optional where Wrapped: ObservableType {
    func trySubscribe(onNext: @escaping (Wrapped.E)->Void) -> Disposable {
        return self?.subscribe(onNext: onNext) ?? Disposables.create()
    }
}

extension SelectionProvider where Self: TableProvider {
    var selected: IndexProperty<Source> {
        return IndexProperty(index: table.rx.selected, content: sources)
    }
    
    var deselected: IndexProperty<Source> {
        return IndexProperty(index: table.rx.deselected, content: sources)
    }
}

extension SelectionProvider where Self: TableProvider, Source.Item: Hashable {
    var selectedRows: ManyIndexProperty<Source> {
        return ManyIndexProperty(selected: selected, deselected: deselected)
    }
    
    var deselectedRows: ManyIndexProperty<Source> {
        return ManyIndexProperty(selected: deselected, deselected: selected)
    }
}

func ||>(rows: TableProvider, disposeBag: DisposeBag) {
    return rows.bind() ||> disposeBag
}
