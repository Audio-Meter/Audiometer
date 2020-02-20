//
//  TestResult.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/7/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation
import UIKit

struct TestResult : Codable, TestInfoProtocol {
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
        return Tests.tone
    }
    var presentableDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        return dateFormatter.string(from: date)
    }
    
    let audiogram: Audiogram
    
    static func test(from string: String?) -> TestResult? {
        guard let data = string?.data(using: .utf8) else {
            return nil
        }
        return (try? JSONDecoder().decode(TestResult.self, from: data))
    }
}
