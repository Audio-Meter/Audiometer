//
//  MiniCogThirdStepViewController.swift
//  Audiometer
//
//  Created by Dogra Tech on 17/03/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtmKit

class MiniCogThirdStepViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CallDelegate {

    @IBOutlet weak var DrawnImage: UIImageView!
    
    var FirstStepCompiltionDetails = [CellData]()
    
    var imagePicker = UIImagePickerController()
    
    var DrawnImagez : UIImage?
       let myPrefixCharacter = "TM"
    let myPrefixColor = UIColor.black
    
    
    @IBOutlet weak var TotalPointLbl: UIButton!
      var Count = 0
    
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
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
           
    override func viewWillAppear(_ animated: Bool) {
        DrawnImage.image = DrawnImagez
    }
    @IBAction func ClickOnPoint(_ sender: UIButton) {
      
        if sender.currentTitle == "-"
        {
            if Count > 0
            {
                Count -= 1
            }
        }
        else
        {
            if Count < 2
            {
                Count += 1
            }
        }
        TotalPointLbl.setTitle(String(Count), for: .normal)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               
               self.DrawnImage.image = image
               
               
           }
           picker.dismiss(animated: true, completion: nil);
       }
    
    
    @IBAction func ScorringBtnClicked(_ sender: UIButton) {
        if sender.currentTitle == "TAKE PICTURE"
               {
                   
                    self.openCamera()
                   
               }
            else if sender.currentTitle == "DRAW"
            {
                let navigation = self.storyboard?.instantiateViewController(withIdentifier: "GPBPaintingViewController") as! GPBPaintingViewController
                                   
                   self.navigationController?.pushViewController(navigation, animated: true)
            }
               else
               {
        var navigation = self.storyboard?.instantiateViewController(withIdentifier: "MiniCogResultViewController") as! MiniCogResultViewController
        
        self.navigationController?.pushViewController(navigation, animated: true)
        }
    }
         func openCamera(){
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                    imagePickerController.allowsEditing = false
                    self.present(imagePickerController, animated: true, completion: nil)
                }
                else{
                    
                    var Alert = UIAlertController(title: "Camera", message: "Camera is not aiavalble ", preferredStyle: .alert)
                    var Okaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    Alert.addAction(Okaction)
                    self.present(Alert,animated: true)
                    
                }
            }
    
   
}
