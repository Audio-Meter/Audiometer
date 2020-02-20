//
//  Observable+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/7/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxSwiftExt

extension ObservableType {
    func delay(_ dueTime: RxTimeInterval) -> Observable<E> {
        return delay(dueTime, scheduler: MainScheduler.instance)
    }
}

struct Rx {
    static func timer(_ dueTime: RxTimeInterval) -> Observable<Void> {
        return Observable<Int>.timer(dueTime, scheduler: MainScheduler.instance).void()
    }
}
