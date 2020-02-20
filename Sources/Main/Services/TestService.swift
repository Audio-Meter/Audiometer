//
//  TestService.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

class TestService {
    func all() -> [PatientTest] {
        return [
            PatientTest(id: "1", date: .parse("May 3, 2017"), type: .tone, result: "", comment: ""),
            PatientTest(id: "2", date: .parse("Sep 1, 2017"), type: .tone, result: "", comment: ""),
            PatientTest(id: "3", date: .parse("Dec 30, 2017"), type: .tone, result: "", comment: ""),
            PatientTest(id: "4", date: .parse("May 3, 2017"), type: .speech, result: "", comment: ""),
            PatientTest(id: "5", date: .parse("Sep 1, 2017"), type: .speech, result: "", comment: "")
        ]
    }
}
