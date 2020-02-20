//
//  Variable+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/13/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

extension Variable {
    var updates: Observable<Element> {
        return asObservable().skip(1)
    }
}
