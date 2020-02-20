//
//  LoginViewController.swift
//  Audiometer
//
//  Created by Eugene Fozekosh on 5/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    var service: AuthorizationServiceProtocol = AuthorizationService()
    
    static let ktoMenuSegueIdentifier = "toMenuSegueIdentifier"
    
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passTextField: UITextField!

    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
            emailTextField.text = "lewisou@gmail.com"
            passTextField.text = "a123456"
        #endif
        UITransparentView()
        
        UIBarButtonItem.appearance().setTitleTextAttributes( [NSAttributedStringKey.font: FontStyle.normal.apply()], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: FontStyle.normal.apply()]
        
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            lblVersion.text = "Version: \(appVersion)\n"
            
        }
        if let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String {
            lblVersion.text = lblVersion.text! + "Build: \(bundleVersion)"
        }
    }
    func UITransparentView()
    {
        emailView.backgroundColor = .clear
        passwordView.backgroundColor = .clear
        
        let borderView = UIView()
        borderView.frame =  CGRect(x: 0, y: 0, width: emailView.frame.width, height: emailView.frame.height)
        borderView.backgroundColor = .clear
        borderView.layer.borderWidth = 3
        borderView.layer.cornerRadius = 10
        borderView.layer.borderColor = UIColor.white.cgColor
        self.emailView.addSubview(borderView)

        let clearView = UIView(frame:borderView.frame.insetBy(dx: 3, dy: 3))
        clearView.backgroundColor = .clear // should be .clear
        self.emailView.addSubview(clearView)
        
        self.emailView.addSubview(self.emailTextField)
        
        
        ////
        
        let borderView2 = UIView()
        borderView2.frame =  CGRect(x: 0, y: 0, width: passwordView.frame.width, height: passwordView.frame.height)
        borderView2.backgroundColor = .clear
        borderView2.layer.borderWidth = 3
        borderView2.layer.cornerRadius = 10
        borderView2.layer.borderColor = UIColor.white.cgColor
        self.passwordView.addSubview(borderView2)

        let clearView2 = UIView(frame:borderView.frame.insetBy(dx: 3, dy: 3))
        clearView2.backgroundColor = .clear // should be .clear
        self.passwordView.addSubview(clearView2)
        self.passwordView.addSubview(self.passTextField)
        
    }
    
    @IBAction func onResetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Forgot password?", message: "Enter your email and we'll send you a temporary password", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Enter your email..."
            textField.keyboardType = .emailAddress
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            guard let emailField = alert.textFields?.first else { return }
            guard let emailText = emailField.text, emailText.isEmpty == false else {
                self.showAlert(title: "Error", message: "Please, enter your email", buttonTitle: "OK")
                return
            }
            self.showProgressHUD()
            self.service.forgotPassword(email: emailText, completion: { (error) in
                self.hideProgressHUD()
                if let error = error {
                    self.showAlert(error: error)
                    return
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLoginTapped() {
        guard let email = self.emailTextField.text, email.count > 0 else {
            self.showAlert(title: "Error", message: "Please, enter your email", buttonTitle: "OK")
            return
        }
        guard let password = self.passTextField.text, password.count > 0 else {
            self.showAlert(title: "Error", message: "Please, enter your password", buttonTitle: "OK")
            return
        }
        self.showProgressHUD()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storage = Storage(storage: appDelegate.persistentContainer)
        storage.login(email: email, password: password, completion: {err in
            self.hideProgressHUD()
            if let error = err {
                self.showAlert(error: error)
                return
            }
            self.performSegue(withIdentifier: LoginViewController.ktoMenuSegueIdentifier, sender: nil)
            self.emailTextField.text = ""
            self.passTextField.text = ""
        })
//        service.login(email: email , password: password) { (err) in
//           self.hideProgressHUD()
//            if let error = err {
//                self.showAlert(error: error)
//                return
//            }
//            self.performSegue(withIdentifier: LoginViewController.ktoMenuSegueIdentifier, sender: nil)
//            self.emailTextField.text = ""
//            self.passTextField.text = ""
//        }
    }
    
    class var viewController: LoginViewController {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passTextField.becomeFirstResponder()
        } else if textField == passTextField {
            onLoginTapped()
        }
        return false
    }
}
