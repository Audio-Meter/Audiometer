//
//  WordService.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/7/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import RxSwift
import os

let localCategory = "Local"

class WordService {
    let syncService = SyncAudioManager()
    
    init() {
        updateCategories()
    }
    
    func sync(completion: @escaping (Error?) -> ()) {
        syncService.syncAudio { [weak self] (error) in
            self?.updateCategories()
            completion(error)
        }
    }
    
    func all() -> [Word] {
        return  srt.map { Word(type: .srt, text: $0, category: localCategory, startPos: 0, endPos: 0) } +
                sd.map { Word(type: .sd, text: $0, category: localCategory, startPos: 0, endPos: 0) }
    }
    
    var category: Variable<[String]> = Variable([localCategory])
    func updateCategories() {
        let allSyncAudioFiles = syncService.allSyncFiles.map({ $0.name ?? "" })
        allSyncAudioFiles.forEach { (item) in
            if !self.category.value.contains(item) { category.value.append(item)}
        }
    }
    
    func all(for fileName: String) -> [Word] {
        let files = syncService.allSyncFiles
        let test = files[0]
        
        let audio = syncService.allSyncFiles.first(where: { $0.name == fileName })
        var results = [Word]()
        guard let wordList = audio?.wordList else {
            return []
        }
        var idx = 0;
        for wordLabel in wordList {
            let word =  Word(type: .srt,
                            text: wordLabel,
                            localPath: audio?.cacheFilePath?.path,
                            category: audio?.category,
                            startPos: (audio?.beginTimePs[idx])!,
                            endPos: (audio?.endTimePs[idx])!)
            results.append(word)
            idx += 1
        }
        return results
    }
    
    //TODO: create without request
    func list(type: SpeechType, index: Int) -> [Word] {
        if index == 0 { // local files
            return all().filter { $0.type == type && $0.category == category.value[index] }
        } else {
            return all(for: category.value[index])
        }
    }

    var srt: [String] {
        return [
            "greyhound",
            "schoolboy",
            "inkwell",
            "whitewash",
            "pancake",
            "mousetrap",
            "eardrum",
            "headlight",
            "birthday",
            "duckpond",
            "sidewalk",
            "hotdog",
            "padlock",
            "mushroom",
            "hardware",
            "workshop",
            "horseshoe",
            "armchair",
            "baseball",
            "stairway",
            "cowboy",
            "iceberg",
            "northwest",
            "railroad",
            "playground",
            "airplane",
            "woodwork",
            "oatmeal",
            "toothbrush",
            "farewell",
            "grandson",
            "drawbridge",
            "doormat",
            "hothouse",
            "daybreak",
            "sunset"
        ]
    }

    var sd: [String] {
        return [
            "an",
            "yard",
            "carve",
            "us",
            "day",
            "toe",
            "felt",
            "stove",
            "hunt",
            "ran",
            "knees",
            "not",
            "mew",
            "low",
            "owl",
            "it",
            "she",
            "high",
            "there",
            "earn",
            "twins",
            "could",
            "what",
            "bathe",
            "ace"
        ]
    }

    var calibration: Word {
        guard let path = Bundle.main.path(forResource: "call_tone", ofType: "wav") else {
            return Word(type: .srt, text: srt[0], category: localCategory, startPos: 0, endPos: 0)
        }
        let word = Word(type: .srt, text: "", localPath: path, category: localCategory, startPos: 0, endPos: 0)
        return word
    }
}
