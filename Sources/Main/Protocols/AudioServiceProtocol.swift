//
//  AudioServiceProtocol.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/24/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

protocol AudioInfo {
    var id: String? { get set }
    var category: String? { get set }
    var fileUrl: String? { get set }
    var wordList: [String]? { get set }
    var alias: String? { get set }
    var base64: String? { get set }
    var fileName: String? { get set }
    var localPath: URL? { get set }
    var userFolder: URL? { get set }
    var cateFolder: URL? { get set }
}

protocol AudioCategoryProtocol {
    var name: String { get set }
}

protocol AudioServiceProtocol {
    func fetchAllAudio(completion: @escaping ([AudioInfo], Error?) -> Void)
    func fetchSingleAudio(id: String, completion: @escaping (AudioInfo?, Error?) -> Void)
}
