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
import AgoraRtmKit

extension Notification.Name {
    static let receiveCall = Notification.Name("receiveCall")
    static let startCall = Notification.Name("startCall")
}

class MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate {
    
    //MARK: properties
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var rightColumn: UIView!
    @IBOutlet weak var menus: UITableView!
    var peerId:String?
    var rtmChannel: AgoraRtmChannel?
    var callObsever:Any?
    var isFirstLoadDone:Bool = false
    
    var container: PersistentContainer!
    var selectRemoteVC:SelectRemoteViewController?
    
    var menuItems = ["TESTS", "CALIBRATION", "CLINIC & CLINICIANS","CHANGE LANGUAGE"]
    
    //HideThe Import Speech File
    //var menuItems = ["TESTS", "CALIBRATION", "CLINIC & CLINICIANS", "IMPORT SPEECH FILES"]
    
    
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

        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(startCall), name: NSNotification.Name.startCall, object: nil)

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
        
        loginUserToChat()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstLoadDone{
            self.loginUserToChat()
        }
        if !isFirstLoadDone{
            isFirstLoadDone = true
        }
        
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
    deinit {
        if let call = callObsever{
            NotificationCenter.default.removeObserver(call)
        }
    }
    
    @objc func startCall(_ notification:Notification){
        self.confirmCallTapped()
    }
    
    func loginUserToChat(){
        
        if let userEmail = Storage.currentUser(){
            AgoraRtm.loginUser(userEmail) {  (errorCode) in
            if let error = errorCode, error != .ok{
                print("login error: \(error.rawValue)")
                return
                }
                self.createChannelForChat(AppId.chatchannel)
            }
            AgoraRtm.updateKit(delegate: self)
        }

    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        AgoraRtm.add(offlineMessage: message, from: peerId)
    }
    
    func createChannelForChat(_ channel:String){
        AgoraRtm.joinChatChannel(forChannel: channel, delegate: self) { [weak self] (errorCode, rtmChannel) in
            guard let rtmChannel = rtmChannel else{
                print("Channel Already exists")
                return
            }
            if let error = errorCode, error != .channelErrorOk{
                print("join channel error: \(error.rawValue)")
            }
            self?.rtmChannel = rtmChannel
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        if member.userId.contains("patient"){
            if let selectVc = selectRemoteVC{
//                selectVc.hideView()
            }
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        if member.userId.contains("patient"){
            if let selectVc = selectRemoteVC{
                selectVc.hideView()
            }
            
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        print("\(member.userId) says \(message.type)")
        
        self.peerId = member.userId
        if let user = Storage.currentUser(){
            
            if let mem = member.userId.components(separatedBy: "-").first{
                AgoraKit.createChannel("\(mem)\(user)")
                AgoraKit.patientName = mem
                _ = AgoraRtm.setChannel(channel: "\(mem)\(user)")
            }
            
        }
        if message.text == MessageHandling.start{
            if (self.presentedViewController != nil){                
                NotificationCenter.default.post(name: Notification.Name.receiveCall, object: self.rtmChannel)
            }else{
                selectRemoteVC = SelectRemoteViewController.viewController
                selectRemoteVC?.callDelegate = self
                selectRemoteVC?.channel = self.rtmChannel
                DispatchQueue.main.async {
                    self.selectRemoteVC?.showViewForParent(self)
                }
            }
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storage = Storage(storage: appDelegate.persistentContainer)

        switch(indexPath.row) {
        case 0:
            PatientsRouter.presentModalPatientsInfo(from: self, rtmChannel: nil)
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
            self.menus.deselectRow(at: indexPath, animated: true)
             let ipadVC = iPadLanguageViewController.viewController
            ipadVC.modalPresentationStyle = .fullScreen
            self.present(ipadVC, animated: true, completion: nil)
//            AudiosRouter.show(from: self)
//            break;
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
        AgoraRtm.logout()
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.viewController
    }
    
    @IBAction func onHelpTapped(_ sender: Any) {
        if let url = User.current?.helpAndInfo.value {
            if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
                // Can open with SFSafariViewController
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true, completion: nil)
            } else {
                // Scheme is not supported or no scheme is given, use openURL
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
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

extension MenuViewController:CallDelegate{
    func cancelTapped() {
        
    }
    
    
    func confirmCallTapped() {
        
        self.rtmChannel?.send(AgoraRtmMessage(text: MessageHandling.confirm), completion: { (error) in
            if error == .errorOk{
                self.rtmChannel?.leave(completion: { (errorCode) in
                    if errorCode == .ok{
                        AgoraRtm.joinChatChannel(forChannel: AgoraRtm.chatChannel ?? "", delegate: self) { [weak self] (errorCode, rtmChannel) in
                            guard let rtmChannel = rtmChannel else{
                                print("Channel Already exists")
                                return
                            }
                            if let error = errorCode, error != .channelErrorOk{
                                print("join channel error: \(error.rawValue)")
                            }
                            DispatchQueue.main.async {
                                self?.selectRemoteVC?.hideView()
                                PatientsRouter.presentModalPatientsInfo(from: self!, rtmChannel: rtmChannel)
                            }
                        }
                    }
                })
            }
        })
    }
    
}
