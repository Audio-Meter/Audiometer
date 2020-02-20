//
//  ButtonIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/21/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import LGButton
import RxSwift

struct ButtonIdea {
    let title: String
    let icon: UIImage

    static var play: ButtonIdea {
        return ButtonIdea(title: "Play", icon: #imageLiteral(resourceName: "PlayButton-1"))
    }

    static var stop: ButtonIdea {
        return ButtonIdea(title: "Stop", icon: #imageLiteral(resourceName: "PauseIcon"))
    }
}

func ||>(lhs: Observable<ButtonIdea>, rhs: LGButton) -> Disposable {
    return lhs.subscribe(onNext: { model in
        rhs.titleString = model.title
        rhs.rightImageSrc = model.icon
    })
}
