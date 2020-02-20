//
//  TitlePickerDataSource2.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class TitlePickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let picker: UIPickerView

    var rows: Rows<String>? {
        didSet {
            picker.reloadAllComponents()
        }
    }

    init(_ picker: UIPickerView) {
        self.picker = picker
        super.init()

        picker.delegate = self
        picker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let rows = rows else {
            return 0
        }
        return rows.numberOfSections
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let rows = rows else {
            return 0
        }
        return rows.numberOfItems(inSection: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let rows = rows else {
            return nil
        }
        let path = IndexPath(row: row, section: component)
        return rows.item(at: path)
    }
}

func ||><T: Rows<String>>(data: Observable<T>, dataSource: TitlePickerDataSource) -> Disposable {
    return data.subscribe(onNext: {
        dataSource.rows = $0
    })
}
