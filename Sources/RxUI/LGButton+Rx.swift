//
//  LGButton+Rx.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/12/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import LGButton
import RxSwift
import RxCocoa

extension Reactive where Base: LGButton {
    var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }

    var title: Binder<String> {
        return Binder(base) { button, text in
            button.titleString = text
        }
    }

    var rightImageSrc: Binder<UIImage> {
        return Binder(base) { button, image in
            button.rightImageSrc = image
        }
    }
}
