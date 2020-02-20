//
//  UIViewController+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    class var identifier: String {
        return String(describing: self).removeSuffix("ViewController").lowerFirst
    }
}

extension Reactive where Base: UIViewController {
    var appeared: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:))).void()
    }

    var disappeared: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).void()
    }
}
