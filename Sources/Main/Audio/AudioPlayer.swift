//
//  AudioPlayer.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/20/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit

protocol AudioPlayer {
    var node: AKNode { get }
}
