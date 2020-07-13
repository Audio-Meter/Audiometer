//
//  MedicalCodesViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/8/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class MedicalCodesViewController : BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var codesNameLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var report: Report!
    var allCodes: Variable<[MedicalCode]> = Variable([])
    
    private var codes: Variable<[MedicalCode]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ICDTableViewCell.nib, forCellReuseIdentifier: ICDTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        
        codesNameLabel.text = self.title
        navigationItem.title = self.title
        
        codes.asObservable().bind(to: tableView.rx.items(cellIdentifier: ICDTableViewCell.reuseIdentifier, cellType: ICDTableViewCell.self)) { [weak self] (_, code, cell) in
            guard let `self` = self else { return }
            cell.bind(code: code, report: self.report)
        }
            .disposed(by: self.disposeBag)
        
        searchBar.textField?.font = FontStyle.normal.apply()
        
        searchBar.rx.text.asObservable().subscribe(onNext: { [weak self] (text) in
            self?.filter(with: text)
        })
            .disposed(by: self.disposeBag)
        
        allCodes.asObservable().subscribe(onNext: { [weak self] _ in
            self?.filter(with: self?.searchBar.text)
        })
            .disposed(by: self.disposeBag)
    }
    
    
    private func filter(with text: String?) {
        if text?.isEmpty == false {
            self.codes.value = self.allCodes.value.filter({ $0.fullName.contains(text!) })
        } else {
            self.codes.value = self.allCodes.value
        }
    }
    
    class func newViewController(report: Report, codes: Variable<[MedicalCode]>) -> MedicalCodesViewController {
        let storyboard = UIStoryboard.codesStoryboard
        let vc = storyboard.instantiateViewController(withIdentifier: "MedicalCodesViewController") as! MedicalCodesViewController
        vc.report = report
        codes.asObservable().subscribe(onNext: { (medicalCodes) in
            vc.allCodes.value = medicalCodes
        }).disposed(by: vc.disposeBag)
        return vc
    }
}
