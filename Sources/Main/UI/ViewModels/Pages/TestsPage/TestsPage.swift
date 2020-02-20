//
//  TestsPage.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/11/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

class TestsPage {
    let app = App()
    
    func toneTestPage(patientId: String, report: Report) -> ToneTestPage {
        return ToneTestPage(app: app, patientId: patientId, report: report)
    }
    
    func wordTestPage(patientId: String, report: Report) -> WordTestPage {
        return WordTestPage(app: app, patientId: patientId, report: report)
    }
}
