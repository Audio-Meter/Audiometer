//
//  SelectRemoteViewController.swift
//  Audiometer
//
//  Created by Arun Jangid on 07/05/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtcKit
import AgoraRtmKit
protocol CallDelegate:class {
    func confirmCallTapped()
    func cancelTapped()
}
extension CallDelegate{
    func cancelTapped(){
        
    }
}

class SelectRemoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class var viewController: SelectRemoteViewController {
        let storyboard = UIStoryboard.mainStoryboard
        return storyboard.instantiateViewController(withIdentifier: "SelectRemoteViewController") as! SelectRemoteViewController
    }
    
    var channel:AgoraRtmChannel?
    weak var callDelegate:CallDelegate?

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bgView: UIView!
        
    @IBAction func dimmissView(_ sender: Any) {
        callDelegate?.cancelTapped()
        if let channel = channel{
            channel.send(AgoraRtmMessage(text: MessageHandling.clinicBusy)) { (erroCodeOk) in
                if erroCodeOk == .errorOk{
                    
                }
            }
        }
        hideView()
    }
    
    @IBAction func confirmCall(_ sender: Any) {
        callDelegate?.confirmCallTapped()
    }
    
    func showViewForParent(_ parentVC:UIViewController){
        let frame = parentVC.view.frame
        self.view.frame = frame
        parentVC.view.addSubview(self.view)
        parentVC.addChild(self)
        
        self.bgView.alpha = 0
        self.shadowView.transform = CGAffineTransform.init(translationX: 0, y: 3 * self.view.frame.width)
        UIView.animate(withDuration: 0.5, animations: {
           self.bgView.alpha = 1
            self.shadowView.transform = CGAffineTransform.identity
        }) { (success) in
        }
    }
    @IBAction func userTapped(_ sender: Any) {
        if let channel = channel{
            channel.send(AgoraRtmMessage(text: MessageHandling.clinicBusy)) { (erroCodeOk) in
                if erroCodeOk == .errorOk{
                    
                }
            }
        }
        callDelegate?.cancelTapped()
        hideView()
    }
    
    func hideView(){
        self.bgView.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.alpha = 0
            self.shadowView.transform = CGAffineTransform.init(translationX: 0, y: 3 * self.view.frame.width)
        }) { (success) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    func hideAndSendBusy(){
        
    }

}
