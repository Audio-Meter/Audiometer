//
//  SelectionProvider.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SelectionProvider {
    associatedtype Source where Source: IndexedRows
    var sources: Observable<Source> { get }
}
