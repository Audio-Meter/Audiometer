//
//  ObservableType+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxSwiftExt

extension ObservableType {
    func wrap() -> Observable<E?> {
        return map { $0 }
    }

    func scan<A>(to variable: Variable<A>, accumulator: @escaping (A, E)->A) -> Disposable {
        return self.subscribe(onNext: {
            variable.value = accumulator(variable.value, $0)
        })
    }

    func void() -> Observable<Void> {
        return mapTo(Void())
    }
}
