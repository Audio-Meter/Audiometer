//
//  ClinicClinicianViewController.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/26/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import UIKit
import os
import CoreData
import EPSignature
import AgoraRtmKit

class ClinicClinicianViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, EPSignatureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CallDelegate {
    
    // MARK: - instance member
    var clinics: [LocalClinic] = []
    var clinicians: [LocalClinician] = []
    let clinicListCellIdentifier = "localClinicListCellId"
    let clinicianListCellIdentifier = "localClinicianListCellId"
    var container: PersistentContainer!
    var storage: Storage!
    
    let imagePicker = UIImagePickerController()
    let clinicCheckboxGroup = BEMCheckBoxGroup()

    // MARK: - outlet
    @IBOutlet weak var clinicTableView: UITableView!
    @IBOutlet weak var clinicianTableView: UITableView!

    @IBOutlet weak var clinicNameField: UITextField!
    @IBOutlet weak var clinicWebsite: UITextField!
    @IBOutlet weak var clinicPhoneField: UITextField!
    @IBOutlet weak var clinicFaxField: UITextField!
    @IBOutlet weak var clinicAddressField: UITextView!
    @IBOutlet weak var clinicSignature: UIImageView!
    
    @IBOutlet weak var clinicianNameField: UITextField!
    @IBOutlet weak var clinicianEmailField: UITextField!
    @IBOutlet weak var certificationField: UITextField!
    @IBOutlet weak var degreesField: UITextField!
    @IBOutlet weak var pcpField: BEMCheckBox!
    @IBOutlet weak var clinicianSignature: UIImageView!
    @IBOutlet weak var clinicLogo: UIImageView!
    
    @IBOutlet weak var clinicSaveBtn: UIButton!
    @IBOutlet weak var clinicianSaveBtn: UIButton!
    @IBOutlet weak var clinicDeleteBtn: UIButton!
    @IBOutlet weak var clinicianDeleteBtn: UIButton!
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    
    // MARK: - bind events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIBarButtonItem.appearance().setTitleTextAttributes( [NSAttributedString.Key.font: FontStyle.normal.apply()], for: .normal)
        
        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)

        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: FontStyle.normal.apply()]
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        
        clinicTableView.delegate = self
        clinicianTableView.delegate = self
        clinicTableView.dataSource = self
        clinicianTableView.dataSource = self
        imagePicker.delegate = self

        storage = Storage(storage: container)
        
        self.clinics = storage.fetchClinics()
        self.clinicTableView.reloadData()

        self.clinicians = storage.fetchClinicians()
        self.clinicianTableView.reloadData()
        
        let service: CliniciansService = CliniciansService()
        service.fetchClinicians { (_clinicians, error) in
            print(_clinicians)
            print(error?.localizedDescription)
        };
    }
    func addCLinicians(){
        let service: CliniciansService = CliniciansService()
        var clinician = Clinician()
        
        clinician.name = "test"
        clinician.email = "test@example.com"
        clinician.degrees = "MBBS"
        clinician.certification = "Certiifcation"
        clinician.pcp = true
        clinician.disabled = true
        
        clinician.password = "test123"
        
        

        service.createNewClinician(info: clinician, completion: { (id, error)  in
            var message = ""
            
            if let e = error {
                message = e.localizedDescription
            } else {
                if id != nil {
                    message = "The clinician is added."

                    clinician.id = id
                    
                    
                    
                } else {
                    message = "The ID is not returned."
                }
            }
            
            let messageWindow = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            messageWindow.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(messageWindow, animated: true)
        })
        
        service.fetchClinicians { (_clinicians, error) in
            print(_clinicians)
            print(error?.localizedDescription)
        };
    }
    

        deinit {
        if let call = callObsever{
                NotificationCenter.default.removeObserver(call)
            }
        }
        
        @objc func recieveCall(_ notification:Notification){
    //        if self.navigationController?.topViewController == nil{
                remoteVC = SelectRemoteViewController.viewController
            if let channel = notification.object as? AgoraRtmChannel{
                remoteVC?.channel = channel
            }
                DispatchQueue.main.async {
                    self.remoteVC?.showViewForParent(self)
                }
                remoteVC?.callDelegate = self
    //        }
        }
        
        func confirmCallTapped() {
            self.dismiss(animated: false, completion: nil)

            NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
        }
    
    @IBAction func clinicianDeleteBtnClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Warning", message: "Would you like to delete this clinician?", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { act in
            self.deleteFocusedClinician()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func clinicDeleteBtnClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Warning", message: "Would you like to delete this clinic?", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { act in
            self.deleteFocusedClinic()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func saveClinicClicked(_ sender: UIButton) {
        saveClinicAndClinicianSelection()
        
        saveFocusedClinic()
    }

    @IBAction func addClinicClicked(_ sender: UIButton) {
        if self.clinics.count > 0 && self.clinics.last?.objectID == nil {
            // The last clinic is the new one without saving.
            return
        } else {
            saveClinicAndClinicianSelection()
            
            self.clinics.append(LocalClinic())
            self.clinicTableView.reloadData()
            
            self.selectListRow(self.clinicTableView,
                               IndexPath(row: self.clinics.count - 1, section: 0))
        }
    }

    @IBAction func addClinicianClicked(_ sender: UIButton) {
        if self.clinicians.count > 0 && self.clinicians.last?.objectID == nil {
            // The last clinic is the new one without saving.
            return
        } else {
            self.addCLinicians()
            saveClinicAndClinicianSelection()
            
            self.clinicians.append(LocalClinician())
            self.clinicianTableView.reloadData()
            
            self.selectListRow(self.clinicianTableView,
                               IndexPath(row: self.clinicians.count - 1, section: 0))
        }
    }
    @IBAction func saveClinicianClicked(_ sender: UIButton) {
        saveClinicAndClinicianSelection()
        
        saveFocusedClinician()
    }
    
    @IBAction func editLogo(_ sender: UIButton) {
        imagePicker.allowsEditing = false

        self.present(imagePicker, animated: true, completion: nil)
    }

    var clinicSignatureEditing = false
    @IBAction func editClinicSigniture(_ sender: UIButton) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
        signatureVC.subtitleText = "Please sign"
        signatureVC.title = "The clinic name"
//        signatureVC.modalPresentationStyle = .fullScreen
        let nav = UINavigationController(rootViewController: signatureVC)
        nav.modalPresentationStyle = .fullScreen

        clinicSignatureEditing = true
        present(nav, animated: true, completion: nil)
    }

    @IBAction func editClinicianSigniture(_ sender: UIButton) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
        signatureVC.subtitleText = "Please sign"
        signatureVC.title = "The clinic name"
//        signatureVC.modalPresentationStyle = .fullScreen
        let nav = UINavigationController(rootViewController: signatureVC)
        nav.modalPresentationStyle = .fullScreen
        
        clinicSignatureEditing = false
        present(nav, animated: true, completion: nil)
    }
    
    
    // MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.clinicTableView {
            return self.clinics.count
        } else {
            return self.clinicians.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.clinicTableView {
            guard let cell = clinicTableView.dequeueReusableCell(withIdentifier: clinicListCellIdentifier, for: indexPath) as? ClinicCell else {
                fatalError("The dequeued cell is not an instance of ClinicClinicianCell.")
            }
            
            guard let name = self.clinics[indexPath.row].name else {
                cell.nameField?.text = ""
                clinicCheckboxGroup.addCheckBox(toGroup: cell.bmcheckbox)
                return cell
            }

            clinicCheckboxGroup.addCheckBox(toGroup: cell.bmcheckbox)
            cell.nameField?.text = name
            cell.bmcheckbox?.on = storage.isClinicSelected(name: name)
            
            return cell
        } else {
            guard let cell = clinicianTableView.dequeueReusableCell(withIdentifier: clinicianListCellIdentifier, for: indexPath) as? ClinicianCell else {
                fatalError("The dequeued cell is not an instance of ClinicClinicianCell.")
            }
            
            guard let name = self.clinicians[indexPath.row].name else {
                cell.nameField?.text = ""
                return cell
            }

            cell.nameField?.text = name
            cell.checkbox?.on = storage.isClinicianSelected(name: name)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        saveClinicAndClinicianSelection()
        if(tableView == clinicTableView) {
            saveFocusedClinic(false)
        } else {
            saveFocusedClinician(false)
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(tableView == clinicTableView) {
            if(self.clinics.count > 0
                && indexPath.row == self.clinics.count - 1
                && self.clinics.last?.objectID == nil) {

                self.clinics.popLast()
                tableView.reloadData()
            }
            
            resetClinicDetailPanel()
        } else {
            if(self.clinicians.count > 0
                && indexPath.row == self.clinicians.count - 1
                && self.clinicians.last?.objectID == nil) {

                self.clinicians.popLast()
                tableView.reloadData()
            }
            
            resetClinicianDetailPanel()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == clinicTableView {

            clinicNameField.text = self.clinics[indexPath.row].name
            clinicNameField.isEnabled = true
            clinicWebsite.text = self.clinics[indexPath.row].website
            clinicWebsite.isEnabled = true
            clinicPhoneField.text = self.clinics[indexPath.row].tel
            clinicPhoneField.isEnabled = true
            clinicFaxField.text = self.clinics[indexPath.row].fax
            clinicFaxField.isEnabled = true
            clinicAddressField.text = self.clinics[indexPath.row].address
            clinicAddressField.isUserInteractionEnabled = true
            if(self.clinics[indexPath.row].signature != nil) {
                clinicSignature.image = UIImage(data: self.clinics[indexPath.row].signature as! Data)
            } else {
                clinicSignature.image = UIImage()
            }
            if(self.clinics[indexPath.row].logo != nil) {
                clinicLogo.image = UIImage(data: self.clinics[indexPath.row].logo as! Data)
            } else {
                clinicLogo.image = UIImage()
            }
            clinicSaveBtn.isEnabled = true
            clinicDeleteBtn.isEnabled = true
        } else {
            clinicianNameField.text = self.clinicians[indexPath.row].name
            clinicianNameField.isEnabled = true
            clinicianEmailField.text = self.clinicians[indexPath.row].email
            clinicianEmailField.isEnabled = true
            certificationField.text = self.clinicians[indexPath.row].certification
            certificationField.isEnabled = true
            degreesField.text = self.clinicians[indexPath.row].degrees
            degreesField.isEnabled = true
            pcpField.setOn(self.clinicians[indexPath.row].pcp ?? false, animated: true)
            pcpField.isEnabled = true
            if(self.clinicians[indexPath.row].signature != nil) {
                clinicianSignature.image = UIImage(data: self.clinicians[indexPath.row].signature as! Data)
            } else {
                clinicianSignature.image = UIImage()
            }
            clinicianSaveBtn.isEnabled = true
            clinicianDeleteBtn.isEnabled = true
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    // MARK: - EPSignatureDelegate
    func epSignature(_: EPSignature.EPSignatureViewController, didCancel error: NSError) {
        
    }
    func epSignature(_: EPSignature.EPSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
        
        let cgImage = signatureImage.cgImage! // better to write "guard" in realm app
        let croppedCGImage = cgImage.cropping(to: boundingRect)
        if(clinicSignatureEditing) {
            clinicSignature.image = UIImage(cgImage: croppedCGImage!)
        } else {
            clinicianSignature.image = UIImage(cgImage: croppedCGImage!)
        }
    }
    
    // MARK: - Image Picker
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let key = UIImagePickerController.InfoKey.editedImage as NSString
        let logoSize = CGSize(width: 340, height: 190)
        guard let image = info[key as UIImagePickerController.InfoKey] as? UIImage else {
            
            let key = UIImagePickerController.InfoKey.originalImage as NSString
            guard let image = info[key as UIImagePickerController.InfoKey] as? UIImage else {
                dismiss(animated: true, completion: nil)
                return
            }

            clinicLogo.image = resizeImage(image: image, targetSize: logoSize)

            dismiss(animated: true, completion: nil)
            return
        }
        clinicLogo.image = resizeImage(image: image, targetSize: logoSize)

        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        // Because saveFocused will refresh the list thus the selection will be lost so save the selection first.
        saveClinicAndClinicianSelection()
        
        saveFocusedClinic(false)
        saveFocusedClinician(false)

        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Private
    private func resetClinicDetailPanel() {
        clinicNameField.text = ""
        clinicWebsite.text = ""
        clinicPhoneField.text = ""
        clinicFaxField.text = ""
        clinicAddressField.text = ""
        clinicSignature.image = UIImage()
        clinicDeleteBtn.isEnabled = false
        clinicSaveBtn.isEnabled = false
    }
    
    private func resetClinicianDetailPanel() {
        clinicianNameField.text = ""
        clinicianEmailField.text = ""
        certificationField.text = ""
        degreesField.text = ""
        pcpField.on = false
        clinicianSignature.image = UIImage()
        clinicianDeleteBtn.isEnabled = false
        clinicianSaveBtn.isEnabled = false
    }
    
    private func deleteFocusedClinic() {
        let row = clinicTableView.indexPathForSelectedRow?.row ?? -1
        if row >= 0 {
            let clinic = clinics[row]
            let nameToDel = clinic.name ?? ""
            if !nameToDel.isEmpty {
                storage.deleteClinicByName(clinicName: nameToDel)
            
                self.clinics = storage.fetchClinics()
                self.clinicTableView.reloadData()
                self.resetClinicDetailPanel()

            }
        }
    }
    
    private func deleteFocusedClinician() {
        let row = clinicianTableView.indexPathForSelectedRow?.row ?? -1
        if row >= 0 {
            let clinician = clinicians[row]
            let nameToDel = clinician.name ?? ""
            if !nameToDel.isEmpty {
                storage.deleteClinicianByName(clinicianName: nameToDel)
            
                self.clinicians = storage.fetchClinicians()
                self.clinicianTableView.reloadData()
                self.resetClinicianDetailPanel()

            }
        }
    }
    
    private func saveFocusedClinic(_ showMess: Bool = true) {
        let row = clinicTableView.indexPathForSelectedRow?.row ?? -1

        if row >= 0 {
            let clinic = clinics[row]
            clinic.name = clinicNameField.text
            clinic.website = clinicWebsite.text
            clinic.tel = clinicPhoneField.text
            clinic.fax = clinicFaxField.text
            clinic.address = clinicAddressField.text
            if(clinicSignature.image != nil) {
                let jpeg = clinicSignature.image!.jpegData(compressionQuality: 1)
                if(jpeg != nil) {
                    clinic.signature = jpeg! as NSData
                } else {
                    clinic.signature = nil
                }
            } else {
                clinic.signature = nil
            }
            if(clinicLogo.image != nil) {
                let jpeg = clinicLogo.image!.jpegData(compressionQuality: 1)
                if(jpeg != nil) {
                    clinic.logo = jpeg! as NSData
                } else {
                    clinic.logo = nil
                }
            } else {
                clinic.logo = nil
            }
            

            if clinic.name?.isEmpty ?? true {
                if showMess {
                    self.notiMessage("Clinic Name should not be empty.")
                }
                return
            }
            
            if(clinic.objectID != nil) {
                storage.updateClinic(clinic: clinic)
                self.clinics[row] = clinic
                self.clinicTableView.reloadData()
                self.selectListRow(self.clinicTableView,
                                   IndexPath(row: row, section: 0))
                
                if showMess {
                    self.notiMessage("Updated!")
                }
            } else {
                let objectID = storage.createClinic(clinic: clinic)
                if(objectID != nil) {
                    clinic.objectID = objectID
                    self.clinics[row] = clinic

                    self.clinicTableView.reloadData()
                    self.selectListRow(self.clinicTableView,
                                       IndexPath(row: row, section: 0))
                    
                    if showMess {
                        self.notiMessage("Created!")
                    }
                }
            }
        }
    }

    private func saveFocusedClinician(_ showMess: Bool = true) {
        var row = clinicianTableView.indexPathForSelectedRow?.row ?? -1
                
        if row >= 0 {
            let clinician = clinicians[row]
            clinician.name = clinicianNameField.text
            clinician.email = clinicianEmailField.text
            clinician.certification = certificationField.text
            clinician.degrees = degreesField.text
            clinician.pcp = pcpField.on
            if(clinicianSignature.image != nil) {
                let jpeg = clinicianSignature.image!.jpegData(compressionQuality: 1)
                if(jpeg != nil) {
                    clinician.signature = jpeg! as NSData
                } else {
                    clinician.signature = nil
                }
            } else {
                clinician.signature = nil
            }
            
            if clinician.name?.isEmpty ?? true {
                if showMess {
                    self.notiMessage("Clinician Name should not be empty.")
                }
                return
            }
            
            if(clinician.objectID != nil) {
                storage.updateClinician(clinician: clinician)
                self.clinicians[row] = clinician
                self.clinicianTableView.reloadData()
                self.selectListRow(self.clinicianTableView,
                                   IndexPath(row: row, section: 0))
                if showMess {
                    self.notiMessage("Saved!")
                }
            } else {
                let objectID = storage.createClinician(clinician: clinician)
                if objectID != nil {
                    self.clinicians[row] = clinician
                    self.clinicians[row].objectID = objectID
                    self.clinicianTableView.reloadData()
                    self.selectListRow(self.clinicianTableView,
                                       IndexPath(row: row, section: 0))

                    if showMess {
                        self.notiMessage("Created!")
                    }
                }
            }
        }
    }
    
    
    private func saveClinicAndClinicianSelection() {
        var rowCount = clinicTableView.numberOfRows(inSection: 0)

        var selectedClinic: String = ""
        var selectedClinicians: [String] = []
        
        var defaultClinicName = ""
        for row in 0 ..< rowCount {
            let cell = clinicTableView.cellForRow(at: NSIndexPath(row: row, section: 0) as IndexPath) as! ClinicCell
            
            let cb = cell.bmcheckbox
            let isSelected = cb?.on
            let name = cell.nameField.text
            defaultClinicName = name ?? "";

            if(cb != nil && cb!.on) {
                guard let name = cell.nameField.text else {
                    continue
                }
                selectedClinic = name
                break;
            }
        }

        rowCount = clinicianTableView.numberOfRows(inSection: 0)
        for row in 0 ..< rowCount {
            let cell = clinicianTableView.cellForRow(at: NSIndexPath(row: row, section: 0) as IndexPath) as! ClinicianCell
            
            if(cell.checkbox.on) {
                guard let name = cell.nameField.text else {
                    continue
                }
                selectedClinicians.append(name)
            }
        }
        
        if selectedClinic.isEmpty {
            selectedClinic = defaultClinicName
        }

        storage.setSelectedClinic(clinicName: selectedClinic)
        storage.setSelectedClinicians(clinicianNames: selectedClinicians)
    }
    
    private func errorMessage(_ mess: String) {
        showAlert(title: "Error", message: mess, buttonTitle: "OK")
    }
    
    private func notiMessage(_ mess: String) {
        showAlert(title: "Notification", message: mess, buttonTitle: "OK")
    }
    
    private func selectListRow(_ list: UITableView, _ _index: IndexPath) {
        guard let index = self.tableView(list, willSelectRowAt: _index) else {
            return
        }

        list.selectRow(at: index, animated: false,
                       scrollPosition: UITableView.ScrollPosition.bottom)
        
        self.tableView(list, didSelectRowAt: index)
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
