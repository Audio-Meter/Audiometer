//
//  Bindable.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

protocol Bindable {
    associatedtype Model
    func bind(model: Model)
}

extension Bindable {
    var klass: Self.Type {
        return Self.self
    }
}
