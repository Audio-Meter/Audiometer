//
//  UIGestureRecognizer+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIGestureRecognizer {
    var recognized: Observable<Void> {
        return event.void()
    }
}
