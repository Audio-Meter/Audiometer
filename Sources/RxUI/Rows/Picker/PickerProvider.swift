//
//  PickerProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

protocol PickerProvider {
    var picker: UIPickerView { get }
}

extension SelectionProvider where Self: PickerProvider {
    var selected: IndexProperty<Source> {
        return IndexProperty(index: picker.rx.selected, content: sources)
    }
}
