//
//  HomeViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    @IBOutlet var calibration: UIButton!
    @IBOutlet var toneTest: UIButton!
    @IBOutlet var wordTest: UIButton!
    @IBOutlet var report: UIButton!
    @IBOutlet var results: UIButton!

    override func viewDidLoad() {
        let page = HomePage()
        bind(model: page)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension HomeViewController: Bindable {
    func bind(model: HomePage) {
        calibration.rx.tap ||> model.calibrationPage ||> navigator.push ||> disposeBag
       // toneTest.rx.tap ||> model.toneTestPage ||> navigator.push ||> disposeBag
       //PatientTestsViewController wordTest.rx.tap ||> model.wordTestPage ||> navigator.push ||> disposeBag
        report.rx.tap ||> model.reportPage ||> navigator.push ||> disposeBag
        results.rx.tap ||> model.resultsPage ||> navigator.push ||> disposeBag
    }
}
