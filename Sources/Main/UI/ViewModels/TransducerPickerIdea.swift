//
//  TransducerPickerIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxCocoa

class TransducerPickerIdea {
    let app: App
    let selectedItem: Variable<Transducer>

    init(app: App) {
        self.app = app
        selectedItem = Variable(app.transducers.list().first!)
    }

    var items: Observable<[Transducer]> {
        return .just(app.transducers.list())
    }

    var selectedName: Observable<String> {
        return selectedItem.asObservable().map { $0.name }
    }
}
