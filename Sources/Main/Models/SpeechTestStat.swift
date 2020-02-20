//
//  SpeechTestStat.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

class SpeechTestStat {
    private let kWrong = "kWrong"
    private let kCorrect = "kCorrect"
    private let kSkip = "kSkip"
    private let kPlayed = "kPlayed"
    
    var playedCount: Int
    var correctCount: Int
    
    var stat: [String: [String : Bool]] = [ : ]
    
    init(playedCount: Int = 0, correctCount: Int = 0, stat: [String: [String : Bool]] = [ : ]) {
        self.playedCount = playedCount
        self.correctCount = correctCount
        self.stat = stat
    }

    var percent: Int? {
        if playedCount == 0 {
            return nil
        }
        return correctCount * 100 / playedCount
    }

    static var zero: SpeechTestStat {
        return SpeechTestStat(playedCount: 0, correctCount: 0)
    }

    func played() -> SpeechTestStat {
        return SpeechTestStat(playedCount: playedCount + 1, correctCount: correctCount, stat: stat)
    }
    
    func markAsPlayed(file: String) -> SpeechTestStat {
        var fileInfo: [String : Bool]! = stat[file]
        if fileInfo == nil {
            fileInfo = [kCorrect : false, kSkip : false, kWrong : true, kPlayed: true]
        }
        stat[file] = fileInfo
        if fileInfo[kSkip] == true {
            return SpeechTestStat(playedCount: playedCount, correctCount: correctCount, stat: stat)
        }
        playedCount += 1
        stat[file] = fileInfo
        return SpeechTestStat(playedCount: playedCount, correctCount: correctCount, stat: stat)
    }
    
//    func markAsCorrect(file: String) -> SpeechTestStat {
//        var fileInfo: [String : Bool]! = stat[file]
//        if fileInfo == nil {
//            correctCount += 1
//            fileInfo = [kCorrect : true, kSkip : false, kWrong : false, kPlayed: false]
//        }
//        fileInfo[kWrong] = false
//        stat[file] = fileInfo
//        if fileInfo[kCorrect] == true {
//            return SpeechTestStat(playedCount: playedCount, correctCount: correctCount, stat: stat)
//        }
//        correctCount += 1
//        fileInfo[kCorrect] = true
//        stat[file] = fileInfo
//        return SpeechTestStat(playedCount: playedCount, correctCount: correctCount, stat: stat)
//    }
    
    func markAsCorrect() -> SpeechTestStat {
        playedCount += 1
        correctCount += 1
        return SpeechTestStat(playedCount: playedCount, correctCount: correctCount)
    }
    
    func skip(file: String) -> SpeechTestStat {
        var fileInfo: [String : Bool]! = stat[file]
        if fileInfo == nil {
            //playedCount -= 1
            fileInfo = [kCorrect : false, kSkip : true, kWrong : false, kPlayed: false]
        }
        stat[file] = fileInfo
        if fileInfo[kSkip] == true {
            return SpeechTestStat(playedCount: playedCount, correctCount: correctCount, stat: stat)
        }
        playedCount -= 1
        fileInfo[kSkip] = true
        return SpeechTestStat(playedCount: playedCount, correctCount: correctCount)
    }
    
//    func wrong(file: String) -> SpeechTestStat {
//        var fileInfo: [String : Bool]! = stat[file]
//        if fileInfo == nil {
//            //correctCount -= correctCount == 0 ? 0 : 1
//            fileInfo = [kCorrect : false, kSkip : true, kWrong : true, kPlayed: false]
//        }
//        fileInfo[kCorrect] = false
//        stat[file] = fileInfo
//        if fileInfo[kWrong] == true {
//            return SpeechTestStat(playedCount: playedCount, correctCount: correctCount, stat: stat)
//        }
//        correctCount -= correctCount == 0 ? 0 : 1
//        fileInfo[kWrong] = true
//        stat[file] = fileInfo
//        return SpeechTestStat(playedCount: playedCount, correctCount: correctCount)
//    }
    
    func wrong() -> SpeechTestStat {
        playedCount += 1
        return SpeechTestStat(playedCount: playedCount, correctCount: correctCount)
    }

}
