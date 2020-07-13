//
//  ToneTestViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import LGButton
import RxSwift
import RxCocoa
import MBProgressHUD
import AudioKit
import AgoraRtcKit
import AgoraRtmKit

class ToneTestViewController: BaseViewController,AgoraRtmDelegate, CallDelegate {
    @IBOutlet var toneSettings: ToneSettingsView!
    @IBOutlet var masking: ToneMaskingView!

    @IBOutlet var amplitudeLabel: UILabel!
    @IBOutlet var frequencyLabel: UILabel!

    @IBOutlet var audiogram: AudiogramView!
    @IBOutlet var swipe: UISwipeGestureRecognizer!

    @IBOutlet var play: LGButton!
    @IBOutlet var record: LGButton!
    @IBOutlet var noResponse: UIButton!
    @IBOutlet var save: LGButton!
    @IBOutlet var bottomBar: UIView!
    @IBOutlet var transducerPlace: UILabel!

    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet var localView: UIView!
    @IBOutlet var remoteView: UIView!
    @IBOutlet weak var localRemoteView: UIView!
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    
    @IBOutlet weak var localRemoteWidthCostrait: NSLayoutConstraint!
    var previousHeight:CGFloat!
    var PreviousModel : PreviousTestsViewModelProtocol!
    
    @IBOutlet weak var mutePatient: UIButton!
    @IBOutlet weak var muteClinic: UIButton!
    @IBOutlet weak var hidePatiet: UIButton!
    @IBOutlet weak var hideCliic: UIButton!
    
    let amplitudeController = SteppedViewController()
    let transducerController = TransducerPickerController()
    let frequencyController = SteppedViewController()
//    let talkController = TalkViewController()

    func setToneTestPage( tonetestPage:ToneTestPage){
        
    }
    
    var agoraKit :AgoraRtcEngineKit!
    var rtmChannel: AgoraRtmChannel?
    var rtmKit :AgoraRtmKit?
    var modelToneTestPage:ToneTestPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.isFromCalibration = false
        
        
        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)

        let font = UIFont.systemFont(ofSize: 20)
        let attrs = [
                    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!
                      ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ToneHistory))

        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        amplitudeController.attach(to: amplitudeLabel)
        amplitudeController.type.removeBorders()
        amplitudeController.type.layer.cornerRadius = 15
        amplitudeController.type.layer.borderWidth = 1
        amplitudeController.type.clipsToBounds = true
        
        transducerController.attach(to: transducerPlace)
        frequencyController.attach(to: frequencyLabel)
        frequencyController.type.removeBorders()
        frequencyController.type.layer.cornerRadius = 15
        frequencyController.type.layer.borderWidth = 1
        frequencyController.type.clipsToBounds = true
//        talkController.attach(to: bottomBar)
        
        setupRtm()

        
    }
    
    
    deinit {
        if let call = callObsever{
                NotificationCenter.default.removeObserver(call)
            }
        }
        
        @objc func recieveCall(_ notification:Notification){
    //        if self.navigationController?.topViewController == nil{
            if let channel = notification.object as? AgoraRtmChannel{
                remoteVC?.channel = channel
            }
                remoteVC = SelectRemoteViewController.viewController
                DispatchQueue.main.async {
                    self.remoteVC?.showViewForParent(self)
                }
                remoteVC?.callDelegate = self
    //        }
        }
        
        func confirmCallTapped() {
            self.navigationController?.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
        }
    
    
    func setupRtm(){
        if let channel = AgoraRtm.rtmChannel{
            self.rtmChannel = channel
            agoraKit = AgoraKit.kit
            AgoraKit.updateKit(delegate: self)
            rtmKit?.agoraRtmDelegate = self
            self.rtmChannel?.channelDelegate = self
            self.setupVideoView()
            self.sendMessage(AgoraRtmMessage(text:MessageHandling.toneTest))
        }
    }
    
    func setupVideoView(){
        
        videoView.frame = CGRect(x: 16, y: 30, width: 300, height: UIScreen.main.bounds.height - 150)
        previousHeight = ((UIScreen.main.bounds.height - 150) - self.buttonsView.frame.height)
        videoView.isHalfHandler = { [weak self] (isHalf)  in
            DispatchQueue.main.async {
                if isHalf{
                    self?.buttonsView.isHidden = true
                    self?.localRemoteView.clipsToBounds = true
                    self?.localRemoteView.frame = CGRect(width: 150, height: 150)
                    
                    self?.localRemoteView.cornerRadius = 75
                    self?.localView.alpha = 0                    
                }else{                    
                    let height = self?.previousHeight ?? ((UIScreen.main.bounds.height - 150) - 396)
                    self?.localRemoteView.frame = CGRect(width: 300, height: height)
                    self?.localRemoteView.cornerRadius = 0
                    
                    self?.buttonsView.isHidden = false
                    self?.localView.alpha = 1
                }
            }            
        }
        
        AgoraKit.setupLocalVideo(self.localView, uid: AgoraKit.myUID)
        if AgoraKit.opponentUID != nil {
            AgoraKit.setupRemoteView(withRemoteView: self.remoteView, uid: AgoraKit.opponentUID)
        }
        
        self.updateButton()
        }
        
        func updateButton() {
            self.remoteView.alpha = AgoraRtm.hideRemote == true ? 0 : 1
            hideCliic.isSelected = AgoraRtm.hideLocal
            hidePatiet.isSelected = AgoraRtm.hideRemote
            muteClinic.isSelected = AgoraRtm.muteClinic
            mutePatient.isSelected = AgoraRtm.mutePatient
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AgoraRtm.rtmChannel != nil{
            self.view.insertSubview(self.videoView, aboveSubview: frequencyController.view)
            videoView.isHidden = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    @IBAction func switchCamera(_ sender:UIButton){
        agoraKit.switchCamera()
    }
    
    @IBAction func mutePatient(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.sendMessage(AgoraRtmMessage(text: MessageHandling.mutePatient))
        }else{
            self.sendMessage(AgoraRtmMessage(text: MessageHandling.unmutePatient))
        }
    }
    @IBAction func muteClinic(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.agoraKit.muteLocalAudioStream(true)
        }else{
            self.agoraKit.muteLocalAudioStream(false)
        }
        
    }
    @IBAction func hidePatientCamera(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.remoteView.alpha = 0
            AgoraRtm.hideRemote = true
        }else{
            self.remoteView.alpha = 1
            AgoraRtm.hideRemote = false
        }
        
    }
    
    @IBAction func hideClinicCamera(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.sendMessage(AgoraRtmMessage(text: MessageHandling.hideClinicCamera))
        }else{
            self.sendMessage(AgoraRtmMessage(text: MessageHandling.unhideClinicCamera))
        }
    }
    
    func sendMessage(_ rawMessage:AgoraRtmRawMessage){
        if let rtmChannel = self.rtmChannel{
            rtmChannel.send(rawMessage) { (erroCode) in
                
            }
        }
        
        
    }
    
    func sendMessage(_ message:AgoraRtmMessage){
        if let rtmchannel = self.rtmChannel{
            rtmchannel.send(message) { (erroCode) in
                
            }
        }
        
    }
    
    
    @objc func ToneHistory()
    {
        
//        let test = TestsPage()
//        let nav = self.storyboard?.instantiateViewController(withIdentifier: "PreviousTestsViewController") as! PreviousTestsViewController

       var viewModel = testinfo.getTheviewmodel()
        
        TestsRouter.showPreviousTests(type: Tests(rawValue: "tone")!, patient: viewModel.patientInfo, from: self, report: viewModel.report)


      //  self.navigationController?.pushViewController(nav, animated: true)
//        
       
    }

    
    class var viewController: ToneTestViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "toneTest") as! ToneTestViewController
    }
}

extension ToneTestViewController: Bindable {
    
    func bind(model: ToneTestPage) {
       
        model.playButton ||> play ||> disposeBag

        toneSettings.bind(model: model.conductionIdea)
        toneSettings.bind(model: model.player)
        masking.bind(model: model.masking)

        
        if AgoraRtm.rtmChannel == nil{
            let audio = AudioManager(players: toneSettings.player, masking.player)
            self ||> audio ||> disposeBag
        }
        


//        play.rx.controlEvent(.touchDown) ||> model.play ||> disposeBag
//        play.rx.controlEvent([.touchUpOutside]) ||> model.pause ||> disposeBag

        
        
        
//        play.rx.tap ||> model.pause ||> disposeBag
        
        
//        play.rx.tap ||> model.toggle ||> disposeBag
        //Added this for video call
        play.rx.tap.bind {
            if AgoraRtm.rtmChannel != nil{
                self.modelToneTestPage = model
                if model.playedVar.value == true{
                    self.sendMessage(AgoraRtmMessage(text: MessageHandling.stopToneTest))
                    model.playedVar.value = false
                }else{
                    self.sendMessage(AgoraRtmMessage(text: MessageHandling.playToneTest))
                    model.playedVar.value = true
                }
            }else{
                model.toggle()
            }
        }.disposed(by: disposeBag)
        
        
        
        
        record.rx.tap ||> model.passed ||> model.record ||> disposeBag
        noResponse.rx.tap ||> model.failed ||> model.record ||> disposeBag

        swipe.rx.recognized ||> model.clearAll ||> disposeBag
        audiogram.rx.tap ||> model.clearAt ||> disposeBag
        model.audiogram ||> audiogram.rx.value ||> disposeBag
        model.frequency ||> audiogram.rx.frequency ||> disposeBag
        model.amplitude ||> audiogram.rx.amplitude ||> disposeBag
        
        save.rx.tap ||> model.testResultPage ||> { [weak self] (testResultPage: TestResultPage<TestResult>) in
            guard let `self` = self else { return }
            // TODO: probably need to add loading property to model and observe it
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            testResultPage.save(with: self.audiogram.asImage()).subscribe(onNext: { [weak self] (success) in
                if success {
                    self?.navigator.back()
                    
                }
                }, onError: { [weak self] (error) in
                    self?.showAlert(error: error)
                }, onDisposed: {
                    hud.hide(animated: true)
            }).disposed(by: self.disposeBag)
            } ||> disposeBag

        amplitudeController.bind(model: model.amplitudeModel)
        frequencyController.bind(model: model.frequencyModel)
        transducerController.bind(model: model.transducerModel)
//        talkController.bind()
    }
}

extension ToneTestPage: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController(page: self) as ToneTestViewController
    }
}

extension ToneTestViewController : AgoraRtmChannelDelegate{
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        
        switch message.type {
        case .text:
            switch message.text {
            case MessageHandling.heardIt:
                self.modelToneTestPage?.playedVar.value = false
                
            case MessageHandling.mutePatient:
                self.mutePatient.isSelected = true
                AgoraRtm.mutePatient = true
            case MessageHandling.unmutePatient :
                self.mutePatient.isSelected = false
                AgoraRtm.mutePatient = false
            default:
                break
            }
            break
        case .raw:break
        default:break
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        if member.userId.contains("patient"){
            let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                DispatchQueue.main.async {
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    AgoraKit.leaveChannel()
                }
            }
            DispatchQueue.main.async {
                self.showAlert(title: "Alert", message: "Patient got disconnected, please wait he will connect with you again.", actions: [action], preferredStyle: .alert)
            }
            
        }
        
    }
}

extension ToneTestViewController:AgoraRtcEngineDelegate{
    
}
