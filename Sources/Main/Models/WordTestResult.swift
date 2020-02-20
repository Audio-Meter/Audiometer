//
//  WordTestResult.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/20/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

struct WordTestResult : Codable, TestInfoProtocol {
    var id: String?
    var date: Date
    var patientId: String
    var comment: String?
    var result: String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    var type: Tests {
        return Tests.speech
    }
    
    var presentableDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        return dateFormatter.string(from: date)
    }
    
    var srt: [Conduction:Int]
    var sd: [Conduction:Int]
    var comfortLevels: [ComfortLevel:[Conduction:Int]]
    
    mutating func add(comment: String?) {
        self.comment = comment
    }

    func update(conduction: Conduction, srt: Int?) -> WordTestResult {
        var result = self
        result.srt[conduction.forWord()] = srt
        return result
    }

    func update(conduction: Conduction, sd: Int?) -> WordTestResult {
        var result = self
        result.sd[conduction.forWord()] = sd
        return result
    }

    func update(comfortLevel: ComfortLevel, conduction: Conduction, amplitude: Int) -> WordTestResult {
        var result = self
        result.comfortLevels = comfortLevels.put([comfortLevel:[conduction:amplitude]])
        return result
    }
    
    func delete(comfortLevel: ComfortLevel, conduction: Conduction, amplitude: Int) -> WordTestResult {
        var result = self
        result.comfortLevels = comfortLevels.delete([comfortLevel:[conduction:amplitude]])
        return result
    }
    
    static func test(patientId: String, comment: String?) -> WordTestResult {
        return WordTestResult(id: nil, date: Date(), patientId: patientId, comment: comment, srt: [:], sd: [:], comfortLevels: [:])
    }
    
    static func test(from string: String?) -> WordTestResult? {
        guard let data = string?.data(using: .utf8) else {
            return nil
        }
        return (try? JSONDecoder().decode(WordTestResult.self, from: data))
    }
}
