//
//  TransducerPickerProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class TransducerPickerProvider: TitlePickerProvider, SelectionProvider {
    let sources: Observable<SectionRows<Transducer>>

    init(picker: UIPickerView, transducers: Observable<[Transducer]>) {
        sources = transducers.map { $0.section() }
        super.init(picker: picker, titles: sources.innerMap { $0.name })
    }
}
