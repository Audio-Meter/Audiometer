//
//  PatientsViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

class PatientsViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    var patientsListViewModel = PatientsListViewModel()
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        bind(model: patientsListViewModel)
        patientsListViewModel.fetchPatients {
            
        }
        
        searchBar.textField?.font = FontStyle.normal.apply()
        
        navigationItem.title = "PATIENTS"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CLOSE", style: .plain, target: self, action: #selector(closeAction))
        
        containerController()?.selectedVCIndex.asObservable().subscribe(onNext: { [weak self] index in
            if index == 0 {
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(self?.saveAction))
            }
            else {
                self?.navigationItem.rightBarButtonItem = nil
            }
        }).disposed(by: disposeBag)
        
        containerController()?.didAddNewPatient.asObservable().subscribe(onNext: { [weak self] didAdd in
            if didAdd == true {
                self?.patientsListViewModel.fetchPatients {}
                self?.containerController()?.clearPatientInfo()
                self?.containerController()?.view.endEditing(true)
                self?.addEmptyViewToTableFooter()
            }
        }).disposed(by: disposeBag)
        
        containerController()?.didUpdatePatient
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] patientInfo in
                guard let patientInfo = patientInfo else { return }
                if let index = self?.patientsListViewModel.update(patientInfo: patientInfo) {
                    self?.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
                }
                self?.containerController()?.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        containerController()?.didDeletePatient
        .asObservable()
        .skip(1)
        .subscribe(onNext: { [weak self] succ in
            if succ == true {
                self?.patientsListViewModel.fetchPatients {}
                self?.containerController()?.clearPatientInfo()
                self?.containerController()?.view.endEditing(true)
            } else {
                self?.notiMessage("Failed to delete the patient.")
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        User.current?.getProfile()
    }
    
    @objc func saveAction() {
        containerController()?.saveAction()
    }
    
    private func addNewPatientLabelToTableFooter() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 45))
        label.font = FontStyle.normal.apply()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "New Patient"
        label.backgroundColor = ColorStyle.semiTransparentBlue.color
        tableView.tableFooterView = label
    }
    
    private func addEmptyViewToTableFooter() {
        tableView.tableFooterView = UIView()
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewPatientAction() {
        guard let contianer = self.containerController() else {
            return
        }
        guard contianer.containsPatientInfo() == false else {
            askUserToChangePatient(patient: nil, indexPath: nil, wasChange: {[weak self] in
                guard let `self` = self else { return }
                self.addNewPatientLabelToTableFooter()
                self.continueCreateNewPatient()
                self.tableView.scrollRectToVisible(self.tableView.tableFooterView!.frame, animated: true)

            })
            return
        }
        addNewPatientLabelToTableFooter()
        continueCreateNewPatient()
        tableView.scrollRectToVisible(tableView.tableFooterView!.frame, animated: true)
    }
    
    private func askUserToChangePatient(patient: PatientInfo?, indexPath: IndexPath?, wasChange: (() -> ())? = nil) {
        guard let contianer = self.containerController() else {
            return
        }
        let changePatientAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            contianer.show(patient: patient)
            if let indexPath = indexPath {
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    cell.isSelected = true
                }
                self.patientsListViewModel.fetchPatients {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
                
            }
            wasChange?()
        })
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        self.showAlert(title: "Warning!",
                        message: "Are you sure you would like to access a different patient record?",
                        actions: [changePatientAction, cancelAction],
                        preferredStyle: .alert)
    }
    
    private func continueCreateNewPatient() {
        if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows {
            for indexPath in indexPathsForVisibleRows {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        containerController()?.clearPatientInfo()
        containerController()?.unlockOnlyInformationScreen()
    }
    
    private func containerController() -> PatientsInfoContainerViewController? {
        let res = childViewControllers.first
        return res as? PatientsInfoContainerViewController
    }
    
    class var viewController: PatientsViewController {
        let storyboard = UIStoryboard(name: "Patients", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "PatientsViewController") as! PatientsViewController
    }
    
    // MARK: - private
    private func notiMessage(_ mess: String) {
        showAlert(title: "Notification", message: mess, buttonTitle: "OK")
    }

}
    // MARK: - ext
extension PatientsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        patientsListViewModel.searchPatients(text: searchText)
    }
}

extension PatientsViewController: Bindable {
    func bind(model: PatientsListViewModel) {
        model.patients.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: BaseAudiometerCell.self)) {[weak self] _, patient, cell in
            cell.textLabel?.text = patient.fullName
            cell.needManualHandleTap = true
                        
            cell.manualTapHandler = { [weak cell] in
                guard let cell = cell else { return }
                if let indexPath = self?.tableView.indexPath(for: cell), let contianer = self?.containerController()  {
                    guard contianer.containsPatientInfo() == true else {
                        let patient = model.patients.value[indexPath.row]
                        contianer.show(patient: patient)
                        cell.isSelected = true
                        self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        self?.addEmptyViewToTableFooter()
                        return
                    }
                    guard cell.isSelected == false else  { return }
                    let patient = model.patients.value[indexPath.row]
                    self?.askUserToChangePatient(patient: patient, indexPath: indexPath, wasChange: {
                        self?.addEmptyViewToTableFooter()
                    })
                }
            }
        }.disposed(by: self.disposeBag)
        
        model.loading.asObservable().subscribe(onNext: { [weak self] loading in
            if loading {
                self?.showProgressHUD()
            }
            else {
                self?.hideProgressHUD()
            }
        }).disposed(by: disposeBag)
        
        // TODO: show error fetching patients
    }
}

extension UISearchBar {

    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            // Fallback on earlier versions
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}
