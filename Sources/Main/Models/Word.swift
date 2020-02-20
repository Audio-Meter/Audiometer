//
//  Word.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit

enum SpeechType: Int {
    case srt, sd
}

protocol AudioFileDetails {
    var type: SpeechType { get }
    var text: String { get }
    var path: String { get }
    var category: String? { get }
}

struct Word: Equatable, AudioFileDetails {
    let type: SpeechType
    let text: String
    let localPath: String?
    var category: String?
    let timeStartPos: Double
    let timeEndPos: Double
    
    var file: AKAudioFile {
        if localPath != nil {
            let fileURL = URL(fileURLWithPath: localPath!)
            os_log("fileURL: %s", localPath!)
            
            do {
                let res = try AKAudioFile(forReading: fileURL)
                return res
            } catch  {
                print(error)
                fatalError(error.localizedDescription)
            }
        }
        
        do {
            let res = try AKAudioFile(readFileName: path)
            return res
        } catch  {
            print(error)
            fatalError(error.localizedDescription)
        }
    }

    var path: String {
        if let localPath = localPath {
            return localPath
        }
        let components = text.components(separatedBy: ".")
        if components.count > 1 {
            return text
        }
        
        return "\(text).wav"
    }

    static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.text == rhs.text
    }
    
    init(type: SpeechType, text: String, localPath: String? = nil, category: String?, startPos: Double, endPos: Double) {
        self.localPath = localPath
        self.text = text
        self.type = type
        self.category = category
        self.timeStartPos = startPos
        self.timeEndPos = endPos
    }
}

