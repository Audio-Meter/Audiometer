//
//  Observable+Rows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import RxCocoa

extension Observable where Element: RowsType {
    func innerMap<Item>(transform: @escaping (Element.Item)->Item) -> Observable<Rows<Item>> {
        return map { rows in
            return rows.map(transform: transform)
        }
    }
}
