//
//  PlayButtonIdea.swift
//  Audiometer
//
//  Created by Sergey Kachan on 4/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class PlayButtonIdea {
    let isPlaying = Variable(false)

    //TODO: Use styles instead
    var styles: Observable<ButtonIdea> {
        return isPlaying.asObservable().map { $0 ? .stop : .play }
    }

    func play() {
        isPlaying.value = true
    }
    
    func pause() {
        isPlaying.value = false
    }

    func toggle() {
        isPlaying.value = !isPlaying.value
    }
}
