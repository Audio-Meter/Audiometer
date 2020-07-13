//
//  PatientsInfoContainerViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/18/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import AgoraRtmKit
import AgoraRtcKit

class PatientsInfoContainerViewController: BaseViewController {
    let selectedVCIndex = Variable(0)
    let didAddNewPatient = Variable(false)
    var didUpdatePatient: Variable<PatientInfo?> = Variable(nil)
    let didDeletePatient = Variable(false)
    
    
    var rtmChannel:AgoraRtmChannel?
    
    var report = Report() {
        didSet {
            historyVC.report = report
            testsVC.report = report
        }
    }
    
    @IBOutlet var segmentedControl: SegmentedControl!
    
    private lazy var patientDetailsVC: PatientDetailsViewController = {
        let res = PatientDetailsViewController.viewController
        res.patientInfo.didAddNewPatient.asObservable() ||> self.didAddNewPatient ||> disposeBag
        res.patientInfo.didUpdatePatient.asObservable() ||> self.didUpdatePatient ||> disposeBag
        res.patientInfo.didDeletePatient.asObservable() ||> self.didDeletePatient ||> disposeBag
        return res
    }()
    
    private lazy var historyVC: TypeOfCodesViewController = {
        return TypeOfCodesViewController.viewController(report: report)
    }()
    
    private lazy var testsVC: TestTypesViewController = {
        let vc = TestTypesViewController.viewController
        vc.report = report        
        return vc
    }()
        
    private lazy var pageController: UIPageViewController = {
        let pageController = UIPageViewController()
        return pageController
    }()
    
    private var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [patientDetailsVC, historyVC, testsVC]
        var pageControllerFrame = self.view.bounds
        pageControllerFrame.size.height -= segmentedControl.frame.height
        pageControllerFrame.origin.y = segmentedControl.frame.height
        self.addChild(pageController)
        view.addSubview(pageController.view)
        pageController.view.frame = pageControllerFrame
        pageController.didMove(toParent: self)
        
        let items = [SegmentItem(title: "INFORMATION", image: #imageLiteral(resourceName: "Information")),
                     SegmentItem(title: "HISTORY", image: #imageLiteral(resourceName: "hist")),
                     SegmentItem(title: "TESTS", image: #imageLiteral(resourceName: "tests"))]
        segmentedControl.setItems(items: items)
        
        segmentedControl.didSelectSectionHandler = { [weak self] index in
            self?.showTab(at: index)            
        }
        let lockedIndexSet: IndexSet = [0, 1, 2]
        patientDetailsVC.view.isUserInteractionEnabled = true
        segmentedControl.lockItems(indexSet: lockedIndexSet)
        showController(at: 0)
    }
    
    @objc func saveAction() {
        patientDetailsVC.patientInfo.save()
    }
    
    func clearPatientInfo() {
        patientDetailsVC.clearPatientInfo()
    }
    
    func show(patient: PatientInfo?, isExisting:Bool? = false) {
        patientDetailsVC.view.isUserInteractionEnabled = true
        showTab(at: 0)
        report = Report()
        report.patient = patient
        let service = AllTestNetworkService()
        //TODO: error handler and method place
        if let id = report.patient?.id {
            service.fetchTests(patientId: id) { (tests, error) in
                self.report.tests = tests
//                self.historyVC.report = self.report
                self.patientDetailsVC.patientInfo.set(patientDetails: patient)
                self.segmentedControl.unlockAllItems()
            }
        }else{
            if AgoraRtm.rtmChannel == nil {
                self.patientDetailsVC.patientInfo.set(patientDetails: patient)
                self.segmentedControl.unlockAllItems()
            }else{
                self.patientDetailsVC.patientInfo.set(patientDetails: patient)
                if let existing = isExisting, existing == true{
                    self.segmentedControl.unlockAllItems()
                }else{
                    self.patientDetailsVC.showAddButton()
                }
                
            }
            
        }
    }
    
    func unlockOnlyInformationScreen() {
        let lockedIndexSet: IndexSet = [1, 2]
        patientDetailsVC.view.isUserInteractionEnabled = true
        segmentedControl.lockItems(indexSet: lockedIndexSet)
    }
    
    func containsPatientInfo() -> Bool {
        return patientDetailsVC.patientInfo.hasAnyPatientDetails
    }
    
    func isEqualTo(patient: PatientInfo) -> Bool {
        return patientDetailsVC.patientInfo.isEqualTo(patient: patient)
    }
    
    // MARK: private
    private func showTab(at index: Int) {
        self.segmentedControl.selectedIndex = index
        self.selectedVCIndex.value = index
        self.showController(at: index)
    }
    
    
    private func showController(at index: Int) {
        let vc = viewControllers[index]
        pageController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
}

