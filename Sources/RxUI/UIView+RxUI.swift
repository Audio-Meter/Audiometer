//
//  UIView+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/18/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIView {
    class var nib: UINib {
        return UINib(nibName: basename, bundle: nil)
    }

    class var basename: String {
        return String(describing: self)
    }
}

extension Reactive where Base: UIView {
    var isShown: Binder<Bool> {
        return Binder(base) {
            $0.isHidden = !$1
        }
    }
}
