//
//  TinnitusTestViewController.swift
//  Audiometer
//
//  Created by Dogra Tech on 02/03/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtmKit

class TinnitusTestViewController: UIViewController,CallDelegate {
    
    ///Tones Outlet
    @IBOutlet weak var toneDot: UIButton!
    @IBOutlet weak var toneLeft: UIButton!
    @IBOutlet weak var toneCenter: UIButton!
    @IBOutlet weak var toneRight: UIButton!
    
    ///Noise Outlet
    @IBOutlet weak var noiseDot: UIButton!
    @IBOutlet weak var noiseLeft: UIButton!
    @IBOutlet weak var noiseCenter: UIButton!
    @IBOutlet weak var noiseRight: UIButton!
    
    
    ///Choices test
    
    @IBOutlet weak var ToneSelected: UIButton!
    @IBOutlet weak var narrowNoiseSelected: UIButton!
    
    
    //////Severity of Tinnitus
    
    @IBOutlet weak var oneClicked: UIButton!
    @IBOutlet weak var twoClicked: UIButton!
    @IBOutlet weak var threeClicked: UIButton!
    @IBOutlet weak var fourClicked: UIButton!
    @IBOutlet weak var fifthClicked: UIButton!
    @IBOutlet weak var sixClicked: UIButton!
    @IBOutlet weak var sevenClicked: UIButton!
    @IBOutlet weak var eightClicked: UIButton!
    @IBOutlet weak var nineClicked: UIButton!
    @IBOutlet weak var tenClicked: UIButton!
    
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)

        
    }
    
    
    @IBAction func SaveBtnClciked(_ sender: UIButton) {
        
        var Svc = self.storyboard?.instantiateViewController(withIdentifier: "TinnitusEvalutionViewController") as! TinnitusEvalutionViewController
        
    self.navigationController?.pushViewController(Svc, animated: true)
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
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
               NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
           }
    
    
}
extension TinnitusTestViewController
{
    
    @IBAction func TonetinnitusClicked(_ sender: UIButton)
    {
        
        if sender.currentTitle == "."
        {
            toneDot.setImage(UIImage(named: "01"), for: .normal)
            toneLeft.setImage(UIImage(named: "02"), for: .normal)
            toneCenter.setImage(UIImage(named: "02"), for: .normal)
            toneRight.setImage(UIImage(named: "02"), for: .normal)
            
            
        }
        else if sender.currentTitle == "left"
        {
            toneDot.setImage(UIImage(named: "02"), for: .normal)
            toneLeft.setImage(UIImage(named: "01"), for: .normal)
            toneCenter.setImage(UIImage(named: "02"), for: .normal)
            toneRight.setImage(UIImage(named: "02"), for: .normal)
        }
        else if sender.currentTitle == "center"
        {
            toneDot.setImage(UIImage(named: "02"), for: .normal)
            toneLeft.setImage(UIImage(named: "02"), for: .normal)
            toneCenter.setImage(UIImage(named: "01"), for: .normal)
            toneRight.setImage(UIImage(named: "02"), for: .normal)
        }
        else if sender.currentTitle == "right"
        {
            toneDot.setImage(UIImage(named: "02"), for: .normal)
            toneLeft.setImage(UIImage(named: "02"), for: .normal)
            toneCenter.setImage(UIImage(named: "02"), for: .normal)
            toneRight.setImage(UIImage(named: "01"), for: .normal)
        }
        
    }
    
    @IBAction func NoiseTinnitusClicked(_ sender: UIButton)
    {
        if sender.currentTitle == "."
        {
            noiseDot.setImage(UIImage(named: "01"), for: .normal)
            noiseLeft.setImage(UIImage(named: "02"), for: .normal)
            noiseCenter.setImage(UIImage(named: "02"), for: .normal)
            noiseRight.setImage(UIImage(named: "02"), for: .normal)
            
            
        }
        else if sender.currentTitle == "left"
        {
            noiseDot.setImage(UIImage(named: "02"), for: .normal)
            noiseLeft.setImage(UIImage(named: "01"), for: .normal)
            noiseCenter.setImage(UIImage(named: "02"), for: .normal)
            noiseRight.setImage(UIImage(named: "02"), for: .normal)
        }
        else if sender.currentTitle == "center"
        {
            noiseDot.setImage(UIImage(named: "02"), for: .normal)
            noiseLeft.setImage(UIImage(named: "02"), for: .normal)
            noiseCenter.setImage(UIImage(named: "01"), for: .normal)
            noiseRight.setImage(UIImage(named: "02"), for: .normal)
        }
        else if sender.currentTitle == "right"
        {
            noiseDot.setImage(UIImage(named: "02"), for: .normal)
            noiseLeft.setImage(UIImage(named: "02"), for: .normal)
            noiseCenter.setImage(UIImage(named: "02"), for: .normal)
            noiseRight.setImage(UIImage(named: "01"), for: .normal)
        }
        
    }
    
    @IBAction func SelectToneOrNoise(_ sender: UIButton) {
        
        if sender.currentTitle == "tone"
        {
            ToneSelected.setImage(UIImage(named: "GreenBox"), for: .normal)
            narrowNoiseSelected.setImage(UIImage(named: "BlackRounded"), for: .normal)
        }
        else if sender.currentTitle == "noise"
        {
            ToneSelected.setImage(UIImage(named: "BlackRounded"), for: .normal)
            narrowNoiseSelected.setImage(UIImage(named: "GreenBox"), for: .normal)
        }
        
    }
    
   
    
    @IBAction func ServityTinnitusClicked(_ sender: UIButton)
    {
        if sender.currentTitle == "1"
        {
            oneClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            
        }
        else if sender.currentTitle == "2"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "3"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "4"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "5"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "6"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "7"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "8"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "9"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
        }
        else if sender.currentTitle == "10"
        {
            oneClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            twoClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            threeClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fourClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            fifthClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sixClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            sevenClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            eightClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            nineClicked.setBackgroundImage(UIImage(named: "NumberBackground"), for: .normal)
            tenClicked.setBackgroundImage(UIImage(named: "SelectedNumber"), for: .normal)
        }
    }
    
}
