//
//  PatientInfoViewController.swift
//  Audiometer
//
//  Created by Arun Jangid on 27/04/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit
import AgoraRtmKit
import AgoraRtcKit
import RxSwift

class PatientInfoViewController: BaseViewController {
    
    var agoraKit :AgoraRtcEngineKit!
    var rtmChannel: AgoraRtmChannel?
    var rtmKit :AgoraRtmKit?
    var peerId:String!
    var lastToneSetting:ToneSendSetting!
    var lastMaskingtest:MaskingTest!
    var lastWordTest:WorkTestSetting!
    var allwordTest:[WorkTestSetting] = []
    
    @IBOutlet weak var fieldsView: UIStackView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    let patientName = "patient\(UUID().uuidString)"
    
    var isStartCalling: Bool = false
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteVideo: UIView!
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var heardIt: UIButton!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIView!
    
    var leaveCount = 0
    var reconnectNewChannelCount = 0
    
    var isSpeechTone:Bool = false
    var isTestTone:Bool = false
    var soundIDSrt : [String:Int] = [:]
    var isRemoteVideoRender: Bool = true {
        didSet {
            remoteVideoMutedIndicator.isHidden = isRemoteVideoRender
            remoteVideo.isHidden = !isRemoteVideoRender
        }
    }
    
    var isLocalVideoRender: Bool = false {
        didSet {
            localVideoMutedIndicator.isHidden = isLocalVideoRender
        }
    }
    
    let tonePlayer = TonePlayer()
    let maskingPlayer = MaskingPlayer()
    let wordPLayer =  WordPlayer()
    var currentToneSetting : ToneSendSetting!
    var audio:AudioManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginUser(patientName)
        let service: CliniciansService = CliniciansService()
        service.fetchClinicians { (arr, error) in
            print(arr)
        }
//        self.setupNotifications()
    }
    
    @IBAction override func pushBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.leaveChannel()
    }
    
    
    //all - automatically stops audio
    //configuresession - it automatically stops audio
    //set category  - it automatically stops audio
    func initializeAgoraEngine(_ channelID:String) {
        // init AgoraRtcEngineKit
        rtmChannel?.leave(completion: { (erroCode) in
            print("leaving first channel \(erroCode.rawValue)")
            if erroCode.rawValue == 0 {
                self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppId.id, delegate: self)
                self.rtmKit = AgoraRtm.kit
                self.rtmKit?.agoraRtmDelegate = self
                AgoraKit.kit = self.agoraKit
                AgoraKit.createChannel(channelID)
                self.joinVideChannel()
//                self.setupAgorakitPlayBack()
                self.reconnectNewChannelCount = 0
                self.agoraKit.setAudioSessionOperationRestriction(AgoraAudioSessionOperationRestriction.deactivateSession)
                self.createChannelForChat(AgoraRtm.setChannel(channel: channelID))
            }else{
                if self.leaveCount < 3{
                    self.initializeAgoraEngine(channelID)
                    self.leaveCount += 1
                }else{
                    //reconnectNewChannelCount
                    DispatchQueue.main.async {
                        self.endCall("Please try again, could not connect")
                    }
                }
            }
        })
    }
    
    func setupAgorakitPlayBack(){
        self.agoraKit.setAudioProfile(.musicStandard, scenario: .chatRoomEntertainment)
        agoraKit.adjustAudioMixingPublishVolume(100)
        self.updateSoundId()
    }
    
    func updateSoundId(){
        
        
        for (index,i) in WordService().srt.enumerated() {
            let file = Bundle.main.path(forResource: "\(i).wav", ofType:nil) ?? "\(i).wav"
            soundIDSrt[file] = index
            self.agoraKit.preloadEffect(Int32(index), filePath: file)
            self.agoraKit.setVolumeOfEffect(Int32(index), withVolume: 100)
        }
        print(soundIDSrt)
        
        
    }
    
    func joinVideChannel(){
        AgoraKit.joinChannel(withChannelName: AgoraKit.channelId, completion: { (chanel, uid, elapsed) in
            DispatchQueue.main.async {
                AgoraKit.setupLocalVideo(self.localVideo, uid: uid)
                self.isLocalVideoRender = true
            }
        })
        self.isStartCalling = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    func setupNotifications() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleRouteChange),
                       name: AVAudioSession.routeChangeNotification,
                       object: nil)
    }

    @objc func handleRouteChange(notification: Notification) {
     guard let userInfo = notification.userInfo,
         let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
         let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
             return
     }
        print("********************************")
        print(reason)
        print("********************************")
     // Switch over the route change reason.
     switch reason {

     case .newDeviceAvailable: // New device found.
         let session = AVAudioSession.sharedInstance()
         
     
     case .oldDeviceUnavailable: // Old device removed.
         if let previousRoute =
             userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
         
         }
     
     default: ()
     }
    }
    
    
    @IBAction func actionHeardIt(_ sender: Any) {
        self.sendMessageToPeer(AgoraRtmMessage(text: MessageHandling.heardIt))
        if self.audio != nil {
            if isSpeechTone{
                isSpeechTone = false
                lastWordTest = nil
                wordPLayer.player.stop()
                maskingPlayer.player.stop()
            }
            if isTestTone{
                isTestTone = false
                tonePlayer.stop()
                maskingPlayer.player.stop()
            }
            
        }
    }
    
    
    deinit {
        if audio != nil {
            audio.stop()
        }
        
        
        leaveChannel()
    }
    
    
    func leaveChannel() {
        // leave channel and end chat
        
        AgoraKit.leaveChannel()
        isStartCalling = false
        isRemoteVideoRender = false
        isLocalVideoRender = false
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    
    func endCall(_ message:String){
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            self.leaveChannel()
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        DispatchQueue.main.async {
            self.showAlert(title: "Alert", message: message, actions: [action], preferredStyle: .alert)
        }
    }
    
    @IBAction func abortHangUp(_ sender: Any) {
        let end = UIAlertAction(title: "End", style: .destructive) { (alert) in
            self.leaveChannel()
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        self.showAlert(title: "Error", message: "Are you sure, you want to end call?", actions: [cancel, end], preferredStyle: .alert)
    }
    func setupUsername(){
        firstName.text = "arun"
        lastName.text = "j"
        emailId.text = "arun@jombay.com"
        phone.text = "9209150770"
    }
    
    @IBAction func actionUpdateData(_ sender: Any) {
        guard !firstName.text!.isEmpty else {
            self.showAlert(title: "Incomplete user details", message: "First Name can't be blank", buttonTitle: "Ok")
            return
        }
        guard !lastName.text!.isEmpty else {
            self.showAlert(title: "Incomplete user details", message: "Last Name can't be blank", buttonTitle: "Ok")
            return
        }
        guard !emailId.text!.isEmpty else {
            self.showAlert(title: "Incomplete user details", message: "Email can't be blank", buttonTitle: "Ok")
            return
        }
        guard !phone.text!.isEmpty else {
            self.showAlert(title: "Incomplete user details", message: "Mobile no. can't be blank", buttonTitle: "Ok")
            return
        }
        
        let userFields = UserFields(firstName: firstName.text ?? "", lastName: lastName.text ?? "" , email: emailId.text ?? "", phone: phone.text ?? "")
        if let data = userFields.toData(){
            let userdata = AgoraRtmRawMessage(rawData: data, description: MessageHandling.userNameDescription)
            sendMessageToPeer(userdata)
        }
    }
    
    func loginUser(_ username:String?){
        if let userName = username{
            AgoraRtm.loginUser(userName) {  (errorCode) in
                if let error = errorCode, error != .ok{
                    print("login error: \(error.rawValue)")
                    return
                }
                AgoraRtm.updateKit(delegate: self)
                self.reconnectNewChannelCount = 0
                self.createChannelForChat(AppId.chatchannel)
            }
        }else{
            print("Enter user name to start receiving messages")
        }
    }
    
    func createChannelForChat(_ channel:String){
        AgoraRtm.joinChatChannel(forChannel: channel, delegate: self) { [weak self] (errorCode, rtmChannel) in
            guard let rtmChannel = rtmChannel else{
                print("Channel Already exists")
                return
            }
            if let error = errorCode, error != .channelErrorOk{
                if let count = self?.reconnectNewChannelCount, count < 3{
                    self?.reconnectNewChannelCount += 1
                    self?.createChannelForChat(channel)
                }else{
                    DispatchQueue.main.async {
                        self?.endCall("Please try again, could not connect")
                    }
                }
                
                print("join channel error: \(error.rawValue)")
            }
            self?.rtmChannel = rtmChannel
            if channel == AppId.chatchannel{
                let message = AgoraRtmRawMessage(text: MessageHandling.start)
                self?.sendMessage(message)
            }
        }
    }
    
    
    func sendMessageToPeer(_ mesasge:AgoraRtmMessage){
        if let channel = rtmChannel{
            channel.send(mesasge) { (errorCode) in
                
            }
        }
    }
    
    func sendMessage(_ message:AgoraRtmRawMessage){
        self.rtmChannel?.send(message, completion: { (errorCode) in
            
        })
    }
    
    
}
extension PatientInfoViewController: AgoraRtcEngineDelegate {
    // first remote video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        DispatchQueue.main.async {
            self.isRemoteVideoRender = true
            AgoraKit.setupRemoteView(withRemoteView: self.remoteVideo, uid: uid)
        }
        print("remote User connected")
        AgoraKit.opponentUID = uid
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState, reason: AgoraVideoRemoteStateReason, elapsed: Int) {
        DispatchQueue.main.async {
            self.isRemoteVideoRender = true
            AgoraKit.setupRemoteView(withRemoteView: self.remoteVideo, uid: uid)
        }
        print("remote User connected")
        AgoraKit.opponentUID = uid
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        isRemoteVideoRender = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        isRemoteVideoRender = !muted
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("Did occur warning \(warningCode)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Did occur error \(errorCode.jsonValue)")
    }
}

extension PatientInfoViewController: AgoraRtmDelegate, AgoraRtmChannelDelegate {
    
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        if self.peerId == peerId{
            switch message.type {
            case .text:
                switch message.text {
                case MessageHandling.confirm: break
                    
                case MessageHandling.receiveName: self.showHeardIt()
                case MessageHandling.toneTest: self.toneTest()
                case MessageHandling.playToneTest:
                    self.agoraKit.disableAudio()
                    tonePlayer.play()
                case MessageHandling.stopToneTest:
                    self.agoraKit.enableAudio()
                    tonePlayer.stop()
                case MessageHandling.speechTest:
                    
                    self.agoraKit.disableAudio()
                    self.setupSpeechTest()
                case MessageHandling.stopAudio:
                    //                    self.agoraKit.enableAudio()
                    if self.audio != nil {
                        self.audio.stop()
                        self.lastWordTest = nil
                        self.lastMaskingtest = nil
                        self.lastToneSetting = nil
                    }
                    
                case MessageHandling.hideCamera:self.agoraKit.disableVideo()
                case MessageHandling.unhideCamera: self.agoraKit.enableVideo()
                case MessageHandling.mutePatient: self.agoraKit.disableAudio()
                case MessageHandling.unmutePatient: self.agoraKit.enableAudio()
                    
                default: break
                    
                }
                
            case .raw:
                if message.text == MessageHandling.receiveName{
                    self.showHeardIt()
                }else if let rawMessage = message as? AgoraRtmRawMessage{
                    if let toneSetting = ToneSendSetting.getToneSendSettings(fromData: rawMessage.rawData){
                        setupToneSetup(toneSetting)
                    }else if let maskSetting = MaskingTest.getToneSendSettings(fromData: rawMessage.rawData){
                        setupMaskingPlayer(maskSetting)
                    }else if let wordSetting = WorkTestSetting.getToneSendSettings(fromData: rawMessage.rawData){
                        setupWordPlayer(wordSetting)
                    }
                    
                }
                break
            default:break
            }
            
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        print("joined \(member.userId)")        
        if !member.userId.contains("patient"){
            let message = AgoraRtmRawMessage(text: MessageHandling.start)
            self.sendMessage(message)
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        if let clinicName = AgoraKit.clinicName{
            if member.userId == clinicName{
                let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                    self.leaveChannel()
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                DispatchQueue.main.async {
                    self.showAlert(title: "Alert", message: "Clinic left, please try after some time", actions: [action], preferredStyle: .alert)
                }
            }
        }
        
        
        
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        switch message.type {
        case .text:
            
            switch message.text {
            case MessageHandling.confirm:
                DispatchQueue.main.async {
                    self.activityindicator.stopAnimating()
                    self.loadingScreen.isHidden = true
                    self.showAlert(title: "Add Details", message: "Please fill your details ", buttonTitle: "Okay")
                    #if DEBUG
                    self.setupUsername()
                    #endif
                    self.abortButton.setTitle("Hang Up", for: .normal)
                    if let mem = self.patientName.components(separatedBy: "-").first{
                        AgoraKit.clinicName = member.userId
                        self.initializeAgoraEngine("\(mem)\(member.userId)")
                    }
                }
                
                self.peerId = member.userId
            case MessageHandling.receiveName:
                self.showHeardIt()
            case MessageHandling.toneTest:
                self.toneTest()
            case MessageHandling.playToneTest:
                //                self.disableAgoraAudio()
                self.playTonetest()
            case MessageHandling.stopToneTest:
                self.stopToneTest()
            //                self.enableAgoraAudio()
            case MessageHandling.playSpeechTest:
                //                self.disableAgoraAudio()
                self.playSpeechTest()
            case MessageHandling.stopSpeechTest:
                self.stopSpeechTest()
            //                self.enableAgoraAudio()
            case MessageHandling.speechTest:
                self.setupSpeechTest()
                break
                
            case MessageHandling.stopAudio:
                if self.isTestTone {
                    self.enableAgoraAudio()
                }
                if self.audio != nil {
                    self.audio.stop()
                }
            case MessageHandling.hideCamera:
                self.enableVideo()
            case MessageHandling.unhideCamera:
                self.disableVideo()
            case MessageHandling.mutePatient:
                self.disableAgoraAudio()
            case MessageHandling.unmutePatient:
                self.enableAgoraAudio()
            case MessageHandling.hideClinicCamera:
                DispatchQueue.main.async {
                    self.remoteVideo.alpha = 0
                }
            case MessageHandling.unhideClinicCamera:
                DispatchQueue.main.async {
                    self.remoteVideo.alpha = 1
                }
                
                
            case MessageHandling.clinicBusy :
                
                let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                    self.leaveChannel()
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                DispatchQueue.main.async {
                    self.showAlert(title: "Alert", message: "Clinic is busy, please try after some time again.", actions: [action, cancel], preferredStyle: .alert)
                }
            default: break
                
            }
            
        case .raw:
            if message.text == MessageHandling.receiveName{
                self.showHeardIt()
            }else if let rawMessage = message as? AgoraRtmRawMessage{
                if let toneSetting = ToneSendSetting.getToneSendSettings(fromData: rawMessage.rawData){
                    setupToneSetup(toneSetting)
                }else if let maskSetting = MaskingTest.getToneSendSettings(fromData: rawMessage.rawData){
                    setupMaskingPlayer(maskSetting)
                }else if let wordSetting = WorkTestSetting.getToneSendSettings(fromData: rawMessage.rawData){
                    setupWordPlayer(wordSetting)
                }
                
            }
            break
        default:break
        }
    }
    
    func disableVideo(){
        if self.agoraKit != nil{
            DispatchQueue.main.async {
                self.agoraKit.disableVideo()
            }
        }
        
    }
    
    func enableVideo(){
        if self.agoraKit != nil{
            DispatchQueue.main.async {
                self.agoraKit.enableVideo()
            }
        }
    }
    
    func disableAgoraAudio(){
        if self.agoraKit != nil{
            DispatchQueue.main.async {
                self.sendMessageToPeer(AgoraRtmMessage(text: MessageHandling.mutePatient))
                self.agoraKit.disableAudio()
            }
        }
    }
    
    func enableAgoraAudio(){
        if self.agoraKit != nil{
            DispatchQueue.main.async {
                self.sendMessageToPeer(AgoraRtmMessage(text: MessageHandling.unmutePatient))
                self.agoraKit.enableAudio()
            }
        }
    }
    
    
    func toneTest(){
        isSpeechTone = false
        isTestTone = true
        if audio != nil {
            audio.stop()
        }
        audio = AudioManager(players: tonePlayer, maskingPlayer)
        audio.start()
                
    }
    
    func playTonetest(){
        print("Play Tone test")
        if !isTestTone{
            self.toneTest()
        }
        
        tonePlayer.play()

        if lastToneSetting != nil{
            self.tonePlayer.toneSendSetting.accept(self.lastToneSetting)
        }
        if lastMaskingtest != nil {
            self.maskingPlayer.update(lastMaskingtest)
        }
    }
    
    func stopToneTest(){
        isTestTone = false
        
        print("Stop Tone test")
        tonePlayer.stop()
        if audio != nil {
            audio.stop()
        }

    }
    
    func setupToneSetup(_ setting:ToneSendSetting) {
        self.lastToneSetting = setting
        print(setting.amplitude)
        if isTestTone == true{            
            self.tonePlayer.toneSendSetting.accept(setting)
        }
    }
    
    
    
    
    func playSpeechTest() {
        wordPLayer.player.stop()
        if audio != nil {
            audio.stop()
        }
        audio = AudioManager(players: wordPLayer, maskingPlayer)
        audio.start()
//        wordPLayer.player.play()
        isSpeechTone = true
    }
    
    func stopSpeechTest(){
        print("stop")
        isSpeechTone = false
        allwordTest.removeAll()
        self.lastWordTest = nil
    }
    
    func setupSpeechTest(){
        print("setupspeechtest")
        //        isSpeechTone = true        
    }
    
    func setupWordPlayer(_ wordSetting:WorkTestSetting){
        if isSpeechTone{
            if self.lastWordTest != nil {
                if self.lastWordTest.text != wordSetting.text{
                    self.lastWordTest = wordSetting
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        if self.isSpeechTone == true{
                            print("playing file \(self.lastWordTest.text ?? "")")
                            self.wordPLayer.update(config: wordSetting)
                        }else{
                            self.wordPLayer.player.stop()
                        }
                    }
                }else{
                    print("change volume")
                    self.lastWordTest = wordSetting
                    var curretWord = wordSetting
                    curretWord.localPath = nil
                    curretWord.isStarted = false
                    
                    self.wordPLayer.update(config: curretWord)
                }
            }else{
                self.lastWordTest = wordSetting
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if self.isSpeechTone == true{
                        print("first file \(self.lastWordTest.text ?? "")")
                        self.wordPLayer.update(config: wordSetting)
                    }else{
                        self.wordPLayer.player.stop()
                    }
//                }                
            }
        }
    }
    
    func playWord(_ config:WorkTestSetting){
        /*
        if let text = config.text, let localPath = config.localPath, let category = config.category, let start = config.timeStartPos, let end = config.timeEndPos{
            let speech = SpeechType(rawValue: config.type ?? 0) ?? SpeechType.srt
            let loopback = false
            let replace = false
            let cycle = 1
            let word = Word(type: speech, text: text, localPath: localPath, category: category, startPos: start, endPos: end)
//
//            agoraKit.setRemoteVoicePosition(<#T##uid: UInt##UInt#>, pan: 0, gain: 0)
//            let success = agoraKit.startAudioMixing(word.path, loopback: loopback, replace: replace, cycle: cycle)
            print(soundIDSrt)
            print(word.path)
            print(soundIDSrt[word.path])
            if let index = soundIDSrt[word.path]{
            
                print(index)
                let success = agoraKit.playEffect(Int32(index), filePath: word.path, loopCount: 0, pitch: 1, pan: config.pan, gain: 1, publish: false)
                print(success)
            }
          */
            
        
        
        

        // Starts audio mixing.
        
    }
    
    
    func setupMaskingPlayer(_ test:MaskingTest){
        if audio != nil{
            
            
                self.maskingPlayer.update(test)
            
            
        }
        self.lastMaskingtest = test
    }
    
    func showHeardIt(){
        DispatchQueue.main.async {
            self.fieldsView.isHidden = true
            self.heardIt.isHidden = false
            self.navView.isHidden = true
            self.updateButton.isHidden = true
            self.view.endEditing(true)
        }
    }
}
