//
//  MenuViewController.swift
//  Audiometer
//
//  Created by Eugene Fozekosh on 5/3/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import Apollo
import MessageUI
import SafariServices
import CoreData

class MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    //MARK: properties
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var rightColumn: UIView!
    @IBOutlet weak var menus: UITableView!

    var container: PersistentContainer!
    
    var menuItems = ["TESTS", "CALIBRATION", "CLINIC & CLINICIANS", "IMPORT SPEECH FILES"]
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let index = menus.indexPathForSelectedRow else {
            return
        }
        menus.deselectRow(at: index, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer

        rightColumn.backgroundColor = ColorStyle.semiTransparentRed.apply()
        rightColumn.isHidden = true
        
        
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            lblVersion.text = "Version: \(appVersion)\n"
        }
        
        if let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String {
            lblVersion.text = lblVersion.text! + "Build: \(bundleVersion)"
        }

        // Load the setting menu if the login user is a Clinic
        // Otherwise load the clinician profile.
        User.current = User()
//        User.current?.getUserCategory {
//            if let uc = User.current?.userCategory {
//                if uc == UserCateogry.clinic {
//                    self.menuItems = ["SETTINGS"]
//                    self.menus.reloadData()
//                } else {
//                    User.current?.getProfile()
//                }
//            }
//        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemCell
        cell.titleLabel.text = self.menuItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        if let selected = cell?.isSelected, selected {
            tableView.deselectRow(at: indexPath, animated: false)
            //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            rightColumn.isHidden = true
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storage = Storage(storage: appDelegate.persistentContainer)

        switch(indexPath.row) {
        case 0:
                PatientsRouter.presentModalPatientsInfo(from: self)
                break;
        case 1:
            guard let userEmail = Storage.currentUser() else {
                break;
            }
            guard let currentUser = storage.getUserByEmail(userEmail) else {
                break;
            }
            
            let userPassword = currentUser.value(forKey: "password") as! String
            
//            guard let userPassword = AuthorizationService.userPassword else {
//                self.showAlert(title: "Please log out", message: "",
//                               actions: [UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
//                               preferredStyle: .alert)
//                return
//            }
            
            let alert = UIAlertController(title: "iAudiometer", message: "Enter Your Password", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                textField.placeholder = "Enter your password..."
                textField.isSecureTextEntry = true                
            })
            
            let loginAction = UIAlertAction(title: "Login", style: .default, handler: { (action) in
                guard let password = alert.textFields?.first?.text, password.isEmpty == false else { return }
                guard userPassword == password else {
                    self.showAlert(title: "Error", message: "Password does not match",
                                   actions: [UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                   preferredStyle: .alert)
                    return
                }
                
                let storyboard = UIStoryboard.mainStoryboard
                let router = Router(storyboard: storyboard)
                
                let calibrationPage = HomePage().calibrationPage()
                let calibrationVC = calibrationPage.createController(router: router)
                
                //TODO: Move this functionality to router
                let navController = UINavigationController(rootViewController: calibrationVC)
                navController.navigationBar.barStyle = .black
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            
            alert.addAction(loginAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            break;
        case 2:
            SettingsRouter.presentModalSettings(from: self, container: container)
            break;
        case 3:
            AudiosRouter.show(from: self)
            break;
        default:
            break
        }
    }
    
    class var viewController: MenuViewController {
        let storyboard = UIStoryboard.authenticationStoryboard
        return storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    }
    
    @IBAction func onLogOutTapped(_ sender: Any){
        ApolloClient.reset()
        User.current = nil
        Storage.setCurrentUser("")
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.viewController
    }
    
    @IBAction func onHelpTapped(_ sender: Any) {
        if let url = User.current?.helpAndInfo.value {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onContactUsTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setToRecipients(["info@melmedtronics.com"])
            mailComposer.mailComposeDelegate = self
            self.present(mailComposer, animated: true, completion: nil)
        } else {
            showAlert(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", buttonTitle: "OK")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
