//
//  TinnitusResultViewController.swift
//  Audiometer
//
//  Created by Dogra Tech on 13/03/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtmKit
class TinnitusResultViewController: UIViewController, CallDelegate {

    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)
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
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
            }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
