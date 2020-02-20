//
//  TestResultViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/7/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import MBProgressHUD

class TestResultViewController: BaseViewController {
    @IBOutlet var audiogram: AudiogramView!
    @IBOutlet var comment: UITextView!
    @IBOutlet var commentLabel: UILabel!
}

extension TestResultViewController: Bindable {
    func bind(model: TestResultPage<TestResult>) {
        title = model.title
        let testResult = model.testResult
        
        let testAudiogram = testResult.audiogram
        audiogram.chart.audiogram = testAudiogram
        comment.text = model.testResult.comment
        
        if model.canEdit {
            let saveButton = UIBarButtonItem(title: "SAVE", style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = saveButton
            saveButton.rx.tap ||> { [weak self] in
                guard let `self` = self else { return }
                // TODO: probably need to add loading property to model and observe it
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                model.save(with: self.audiogram.asImage()).subscribe(onNext: { [weak self] (success) in
                    if success {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }, onError: { [weak self] (error) in
                    self?.showAlert(error: error)
                }, onDisposed: {
                    hud.hide(animated: true)
                }).disposed(by: self.disposeBag)
            } ||> disposeBag
        } else {
            let reportButton = UIBarButtonItem(title: "REPORT", style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = reportButton
            reportButton.rx.tap ||> { [weak self] in
                guard let `self` = self else { return }
                ReportsRouter.show(report: model.report, from: self)
            } ||> disposeBag
            
            commentLabel.text = "COMMENTS"
        }
        
        audiogram.isUserInteractionEnabled = model.canEdit
        comment.isUserInteractionEnabled = model.canEdit
        comment.rx.text.subscribe(onNext: { text in
            model.testResult.comment = text
        }).disposed(by: disposeBag)
   }
}
