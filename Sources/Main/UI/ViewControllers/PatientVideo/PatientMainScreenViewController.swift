//
//  PatientMainScreenViewController.swift
//  Audiometer
//
//  Created by Arun Jangid on 27/04/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit

extension UIViewController{
    @IBAction func pushBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIDevice{
    func isIPAD() -> Bool{
        if UIDevice.current.userInterfaceIdiom == .pad {
           return true
        }
        return false
    }
    
    func isiPhone() -> Bool{
        if UIDevice.current.userInterfaceIdiom == .phone {
           return true
        }
        return false
    }
    
}

class PatientMainScreenViewController: UIViewController {

    class var viewController:UINavigationController{
        return UIStoryboard.patientVideo.instantiateViewController(withIdentifier: "NavPatientMainScreenViewController") as! UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalClinicService.fetchLocalClinics { (arr, error) in
            print(arr)
            print(error)
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {

    }
    
    @IBAction func languageTapped(_ sender: Any) {
    }
    

}
