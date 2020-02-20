//
//  HomePage.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

class HomePage {
    let app = App()

//    @available(*, deprecated, message: "Use this method from TestsPage class")
//    func toneTestPage() -> ToneTestPage {
//        return ToneTestPage(app: app)
//    }
//
//    @available(*, deprecated, message: "Use this method from TestsPage class")
//    func wordTestPage() -> WordTestPage {
//        return WordTestPage(app: app)
//    }

    func calibrationPage() -> CalibrationPage {
        return CalibrationPage(app: app)
    }

    func reportPage() -> Report1Page {
        return Report1Page(report: Report())
    }

    func resultsPage() -> TestReportPage {
        return TestReportPage()
    }
}
