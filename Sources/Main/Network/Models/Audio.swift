//
//  Audio.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

struct Audio: AudioInfo {
    var id: String?
    var fileName: String?
    var category: String?
    var fileUrl: String?
    var wordList: [String]?
    var wordListRaw: String?
    var base64: String?
    var alias: String?
    var localPath: URL?
    var userFolder: URL?
    var cateFolder: URL?
}
