//
//  PatientDetailsViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import os

class PatientDetailsViewController: BaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var reportButton: UIButton!
    @IBOutlet var exportButton: UIButton!

    lazy var patientInfo: PatientPage = {
        return PatientPage()
    }()
    
    private var provider: DetailsCollectionProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(model: patientInfo)
        provider = DetailsCollectionProvider(collectionView: collectionView, info: patientInfo)
    }
    
    func clearPatientInfo() {
        patientInfo.set(patientDetails: nil)
    }
    
    @IBAction func exportAction(sender: UIButton) {
      //  ReportsRouter.s
    }
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.patientInfo.delete()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        self.showAlert(title: "Warning!",
                        message: "Are you sure you would like to delete the patient record?",
                        actions: [yesAction, noAction],
                        preferredStyle: .alert)
    }
    
    class var viewController: PatientDetailsViewController {
        let storyboard = UIStoryboard(name: "Patients", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "PatientDetailsViewController") as! PatientDetailsViewController
    }
}

extension PatientDetailsViewController: Bindable {
    func bind(model: PatientPage) {
        model.lastError.asObservable().subscribe(onNext: { [weak self] error in
            if let error = error {
                self?.showAlert(error: error)
            }
        }).disposed(by: disposeBag)
        
        model.loading.asObservable().subscribe(onNext: { [weak self] loading in
            if loading {
                self?.showProgressHUD()
            }
            else {
                self?.hideProgressHUD()
            }
        }).disposed(by: disposeBag)
    }
}
