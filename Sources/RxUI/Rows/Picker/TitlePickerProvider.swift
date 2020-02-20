//
//  TitlePickerProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TitlePickerProvider: PickerProvider {
    let picker: UIPickerView
    let titles: Observable<Rows<String>>

    init(picker: UIPickerView, titles: Observable<Rows<String>>) {
        self.picker = picker
        self.titles = titles
    }

    func bind() -> Disposable {
        return titles ||> dataSource
    }

    lazy var dataSource: TitlePickerDataSource = {
        let dataSource = TitlePickerDataSource(self.picker)
        picker.dataSource = dataSource
        return dataSource
    }()
}

func ||>(rows: TitlePickerProvider, disposeBag: DisposeBag) {
    return rows.bind() ||> disposeBag
}
