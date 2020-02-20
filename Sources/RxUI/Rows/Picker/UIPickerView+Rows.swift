//
//  UIPickerView+Rows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIPickerView {
    var selected: ControlProperty<IndexPath?> {
        let values = itemSelected.map {
            IndexPath(row: $0.row, section: $0.component) as IndexPath?
        }
        return ControlProperty(values: values, valueSink: Binder(base) { picker, path in
            if let path = path {
                picker.selectRow(path.row, inComponent: path.section, animated: false)
            }
        })
    }
}
