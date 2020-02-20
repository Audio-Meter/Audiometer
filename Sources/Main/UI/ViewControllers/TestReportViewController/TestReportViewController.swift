//
//  TestReportViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/29/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class TestReportViewController: FreeViewController {
    override func loadView() {
        view = TestReportView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Results"
    }
}

extension TestReportViewController: Bindable {
    func bind(model: TestReportPage) {
        let rootView = view as! TestReportView
        rootView.bind1(values: model.data1)
        rootView.bind2(values: model.data2)
        rootView.bind4(values: model.data4)

        rootView.audiogram.chart.audiogram = model.audiogram
    }
}

extension TestReportPage: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController2(page: self) as TestReportViewController
    }
}
