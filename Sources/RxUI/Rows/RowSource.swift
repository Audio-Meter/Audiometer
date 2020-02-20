//
//  RowSource.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

protocol RowSource {
    var numberOfSections: Int { get }
    func numberOfItems(inSection: Int) -> Int
}
