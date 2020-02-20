//
//  PreviousTestsViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/23/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class PreviousTestsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startNewTestButton: UIButton!
    var viewModel: PreviousTestsViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.title = viewModel.testType.description
        
        let buttonTitle = "START NEW " + viewModel.title + " TEST"
        startNewTestButton.setTitle(buttonTitle, for: .normal)
        bind(model: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTests()
    }
    
    private func startNewTest() {
        TestsRouter.showTest(type: viewModel.testType,
                             patient: viewModel.patientInfo,
                             from: self,
                             report: viewModel.report)
    }
    
    class var viewController: PreviousTestsViewController {
        let storyboard = UIStoryboard.testsStoryboard
        return storyboard.instantiateViewController(withIdentifier: "PreviousTestsViewController") as! PreviousTestsViewController
    }
}

extension PreviousTestsViewController: Bindable {
    func bind(model: PreviousTestsViewModelProtocol) {
        viewModel.tests.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { _, testInfo, cell in
            cell.textLabel?.text = testInfo.presentableDateString
        }.disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
            let testInfo = self.viewModel.testInfo(at: indexPath)
            TestsRouter.showHistoryTest(info: testInfo, from: self, report: model.report)
        }).disposed(by: disposeBag)
        
        model.loading.asObservable().subscribe(onNext: { [weak self] loading in
            loading ? self?.showProgressHUD() : self?.hideProgressHUD()
        }).disposed(by: disposeBag)
        
        startNewTestButton.rx.tap ||> { [weak self] in self?.startNewTest() } ||> disposeBag
    }
}
