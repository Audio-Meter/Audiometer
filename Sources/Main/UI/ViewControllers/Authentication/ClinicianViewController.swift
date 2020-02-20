//
//  ClinicianViewController.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 7/15/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import os
import UIKit

class ClinicianViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: properties
    @IBOutlet weak var clinicianList: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var certificationTextField: UITextField!
    @IBOutlet weak var degreesTextField: UITextField!
    @IBOutlet weak var detailArea: UIStackView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var newClinicianBtn: UIButton!
    @IBOutlet weak var pcpCheckBox: BEMCheckBox!
    @IBOutlet weak var disableCheckBox: BEMCheckBox!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var leftColumn: UIView!
    let service: CliniciansService = CliniciansService()
    let cellIdentifier = "clinicianItemCellID"
    
    var cliniciansAfterFilter: [Clinician] = []
    var cliniciansOrigin: [Clinician] = []
    var cliniciansBeforeFilter: [Clinician] = []
    var searchText = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clinicianList.delegate = self
        clinicianList.dataSource = self

        let fields = [nameTextField, emailTextField, certificationTextField, degreesTextField, passwordTextField]
        for field in fields {
            if let f = field {
                f.setBottomBorder()
            }
        }
    
        //detailArea.setLeftBorder()
        leftColumn.setRightBorder()
        
        service.fetchClinicians { (_clinicians, error) in
            if(error == nil) {
                self.cliniciansOrigin = []
                for _clinician in _clinicians {
                    self.cliniciansOrigin.append(_clinician);
                }
                self.cliniciansAfterFilter = self.cliniciansOrigin
                
                self.searchBar.delegate = self;
                
                
                self.clinicianList.reloadData()
            }
        };
        

    }
    
    //MARK: - Events
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        if let indexPath = clinicianList.indexPathForSelectedRow {
            var clinician = cliniciansAfterFilter[indexPath.row]
            
            clinician.name = nameTextField.text ?? ""
            clinician.email = emailTextField.text ?? ""
            clinician.degrees = degreesTextField.text ?? ""
            clinician.certification = certificationTextField.text ?? ""
            clinician.pcp = pcpCheckBox.on
            clinician.disabled = disableCheckBox.on
            if let passwd = passwordTextField.text {
                clinician.password = passwd
            } else {
                clinician.password = nil
            }
            
            if clinician.id == nil {
                service.createNewClinician(info: clinician, completion: { (id, error)  in
                    var message = ""
                    
                    if let e = error {
                        message = e.localizedDescription
                    } else {
                        if id != nil {
                            message = "The clinician is added."

                            clinician.id = id
                            self.cliniciansAfterFilter[indexPath.row] = clinician
                            self.cliniciansOrigin.append(clinician)
                            self.clinicianList.reloadData()

                            
                            self.selectRow(indexPath);
                        } else {
                            message = "The ID is not returned."
                        }
                    }
                    
                    let messageWindow = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                    messageWindow.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageWindow, animated: true)
                })
            } else {
                service.editClinician(info: clinician, completion: { (error) in
                    var message = ""
                    
                    if let e = error {
                        message = e.localizedDescription
                    } else {
                        message = "The clinician is updated."
                        self.cliniciansAfterFilter[indexPath.row] = clinician
                        self.clinicianList.reloadData()

                        self.selectRow(indexPath)
                    }
                    
                    let messageWindow = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                    messageWindow.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageWindow, animated: true)
                })
            }
        }
    }
    
    @IBAction func newClinicianBtnClicked(_ sender: UIButton) {
        let clinician = Clinician()
        cliniciansAfterFilter.append(clinician)
        clinicianList.reloadData()
        
        let indexPath = IndexPath(row: cliniciansAfterFilter.count - 1, section: 0);

        selectRow(indexPath)
    }
    
    // MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        resetDetailArea()

        if searchText.isEmpty {
            self.cliniciansAfterFilter = self.cliniciansOrigin
            
            clinicianList.reloadData()
            return
        }
        
        self.cliniciansAfterFilter = []
        for clinician in self.cliniciansOrigin {
            let lowerCaseName = clinician.name?.lowercased()
            let lowerCaseSearchText = searchText.lowercased()
            if lowerCaseName != nil
                && lowerCaseName?.contains(lowerCaseSearchText) ?? false {
                self.cliniciansAfterFilter.append(clinician)
            }

            clinicianList.reloadData()
        }
    }
    
    // MARK: - Table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cliniciansAfterFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = clinicianList.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ClinicianItemCell else {
            fatalError("The dequeued cell is not an instance of ClinicianItemCell.")
        }

        let clinician = self.cliniciansAfterFilter[indexPath.row]
        if clinician.id == nil {
            cell.nameLabel?.text = "New"
        } else {
            cell.nameLabel?.text = clinician.name ?? "N / A"
        }
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let lastClinician = cliniciansAfterFilter.last else {
            // do nothing
            return indexPath
        }
        
        if(lastClinician.id == nil) {
            if(indexPath.row < cliniciansAfterFilter.count - 1) {
                cliniciansAfterFilter.popLast()
                clinicianList.reloadData()
                newClinicianBtn.isEnabled = true
            } else {
                newClinicianBtn.isEnabled = false
            }
        } else if (lastClinician.id != nil) {
            newClinicianBtn.isEnabled = true
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clinician = self.cliniciansAfterFilter[indexPath.row]

        nameTextField.text = clinician.name
        emailTextField.text = clinician.email
        certificationTextField.text = clinician.certification
        degreesTextField.text = clinician.degrees
        pcpCheckBox.on = clinician.pcp ?? false
        disableCheckBox.on = clinician.disabled ?? false
        passwordTextField.text = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private
    func selectRow(_ indexPath: IndexPath) {
        self.tableView(clinicianList, willSelectRowAt: indexPath)
        
        
        self.clinicianList.selectRow(at: indexPath,
                                     animated: false,
                                     scrollPosition: UITableViewScrollPosition.bottom)
        
        self.tableView(clinicianList, didSelectRowAt: indexPath)
    }

    func resetDetailArea() {
        nameTextField.text = nil
        emailTextField.text = nil
        passwordTextField.text = nil
        degreesTextField.text = nil
        certificationTextField.text = nil
        pcpCheckBox.on = false
        disableCheckBox.on = false
    }
}
