//
//  Report2ViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/16/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EPSignature
import MBProgressHUD

class Report2ViewController: BaseViewController {
    @IBOutlet var done: UIBarButtonItem!
    @IBOutlet var prevPage: UIBarButtonItem!
    @IBOutlet var comment: UITextView!
    @IBOutlet var other: UITableView!
    @IBOutlet var tests: UITableView!
    @IBOutlet weak var signature: UIImageView!
    @IBOutlet weak var addSignature: UIButton!
    
    var otherProvider: CodeTableProvider!
    var testsProvider: PatientTestTableProvider!
}

extension Report2ViewController: Bindable {
    func bind(model: Report2Page) {
        //TODO: make more reactive
        var service = ReportService()
        service.report = model.report.value
        signature.image = model.signature.value 
        done.rx.tap ||>  service.createReport ||> disposeBag
        service.creating ||> { [weak self] (creating: Bool) in
            guard let `self` = self else { return }
            let viewForHud = self.view!
            self.done.isEnabled = !creating
            if creating {
                let hud = MBProgressHUD.showAdded(to: viewForHud, animated: true)
                hud.label.text = "Generating report"
            } else {
                MBProgressHUD.hide(for: viewForHud, animated: true)
            }
            } ||> disposeBag
        service.url ||> navigator.showSafariViewController ||> disposeBag
        prevPage.rx.tap ||> model.store ||> model.report ||> disposeBag
        prevPage.rx.tap ||> navigator.back ||> disposeBag
        comment.rx.value <||> model.comment ||> disposeBag
        comment.rx.text.orEmpty
            .bind(to: service.report.comment)
            .disposed(by: disposeBag)
        
//        otherProvider = CodeTableProvider(table: other, cells: model.otherRows, report: service.report)
//        otherProvider ||> disposeBag
        
        
        testsProvider = PatientTestTableProvider(table: tests, tests: model.tests)
        testsProvider ||> disposeBag
        testsProvider.deselectedRows ||> model.selectedTests ||> disposeBag
        
        for sec in 0..<tests.numberOfSections {
            let totalRows = tests.numberOfRows(inSection: sec)
            for row in 0..<totalRows {
                tests.delegate?.tableView!(tests, didDeselectRowAt: IndexPath(row: row, section: sec))
            }
        }
    }
}

extension Report2Page: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController(page: self) as Report2ViewController
    }
}
