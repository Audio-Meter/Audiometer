//
//  WordTestResultViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/29/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import MBProgressHUD

class WordTestResultViewController: BaseViewController {
    @IBOutlet var result: WordTestResultView!
    @IBOutlet var comment: UITextView!
    @IBOutlet var commentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WordTestResultViewController: Bindable {
    func bind(model: TestResultPage<WordTestResult>) {
        let testComment = model.testResult.comment
        let wordTestWM = WordTestResultViewModel(patientId: model.testResult.patientId, comment: testComment!)
        wordTestWM.values.value = model.testResult
        result.bind(model: wordTestWM)
        
        if model.canEdit {
            let saveButton = UIBarButtonItem(title: "SAVE", style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = saveButton
            saveButton.rx.tap ||> { [weak self] in
                guard let `self` = self else { return }
                // TODO: probably need to add loading property to model and observe it
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                model.save(with: self.result.asImage()).subscribe(onNext: { [weak self] (success) in
                    if success {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    }, onError: { [weak self] (error) in
                        self?.showAlert(error: error)
                    }, onDisposed: {
                        hud.hide(animated: true)
                }).disposed(by: self.disposeBag)
                } ||> disposeBag
        }
        else {
            let reportButton = UIBarButtonItem(title: "REPORT", style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = reportButton
            reportButton.rx.tap ||> { [weak self] in
                guard let `self` = self else { return }
                ReportsRouter.show(report: model.report, from: self)
                } ||> disposeBag
            
            commentLabel.text = "COMMENTS"
        }
        
        comment.text = testComment
        comment.isUserInteractionEnabled = model.canEdit
        comment.rx.text.subscribe(onNext: { text in
            model.testResult.add(comment: text)
        }).disposed(by: disposeBag)
    }
}
