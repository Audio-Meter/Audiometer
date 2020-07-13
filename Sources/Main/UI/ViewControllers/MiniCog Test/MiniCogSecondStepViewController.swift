//
//  MiniCogSecondStepViewController.swift
//  Audiometer
//
//  Created by Dogra Tech on 17/03/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtmKit

class MiniCogSecondStepViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CallDelegate {

    
    var FirstStepCompiltionDetails = [CellData]()
    @IBOutlet weak var DrawImage: UIImageView!
      var imagePicker = UIImagePickerController()
    
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
            func cancelTapped() {
                
            }
            
            func confirmCallTapped() {
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
            }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.DrawImage.image = image
            
            
        }
        picker.dismiss(animated: true, completion: nil);
    }

    @IBAction func NextStepClicked(_ sender: UIButton) {
        
        
        if sender.currentTitle == "TAKE PICTURE"
        {

             self.openCamera()

        }
    else if sender.currentTitle == "DRAW"
            {
                let navigation = self.storyboard?.instantiateViewController(withIdentifier: "GPBPaintingViewController") as! GPBPaintingViewController
                    
        
                navigation.FirstStepCompiltionDetails = FirstStepCompiltionDetails
                
        self.navigationController?.pushViewController(navigation, animated: true)
                
            }
        else
        {
        var navigation = self.storyboard?.instantiateViewController(withIdentifier: "MiniCogThirdStepViewController") as! MiniCogThirdStepViewController

               self.navigationController?.pushViewController(navigation, animated: true)
         }
       
    }
    func openGallary()
       {
           imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           imagePicker.allowsEditing = true
           imagePicker.delegate = self
           self.present(imagePicker, animated: true, completion: nil)
       }
       
    
     func openCamera(){
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                imagePickerController.allowsEditing = false
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
//                let alert = UIAlertController.alert(title: "Camera", msg: "No camera is available for this device")
//                present(alert, animated: true, completion: nil)
                
                var Alert = UIAlertController(title: "Camera", message: "Camera is not aiavalble ", preferredStyle: .alert)
                var Okaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                Alert.addAction(Okaction)
                self.present(Alert,animated: true)
                
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

}
