//
//  ClinicViewController.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/5/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import UIKit

class ClinicViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var faxTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let service: ClinicService = ClinicService()

    override func viewDidLoad() {
        super.viewDidLoad()

        let textFields = [emailTextField,
                          telephoneTextField,
                          faxTextField,
                          websiteTextField,
                          passwordTextField]
        
        for tf in textFields {
            tf?.setBottomBorder()
        }

        service.getProfile { (clinic, error) in
            if(error == nil) {
                self.emailTextField.text = clinic?.email ?? ""
                self.telephoneTextField.text = clinic?.phone ?? ""
                self.faxTextField.text = clinic?.fax ?? ""
                self.websiteTextField.text = clinic?.website ?? ""
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        var clinic = Clinic()
        clinic.email = emailTextField.text
        clinic.fax = faxTextField.text
        clinic.phone = telephoneTextField.text
        clinic.website = websiteTextField.text
        clinic.password = passwordTextField.text
        
        service.updateProfile(profile: clinic) { (error) in
            var message = ""
            
            if let e = error {
                message = e.localizedDescription
            } else {
                message = "The profile is updated."
            }
            
            let messageWindow = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            messageWindow.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(messageWindow, animated: true)
        }
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
    

}
