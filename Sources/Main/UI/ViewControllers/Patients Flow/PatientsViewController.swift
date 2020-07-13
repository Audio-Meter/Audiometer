//
//  PatientsViewController.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift
import AgoraRtmKit
import AgoraRtcKit

class PatientsViewController: BaseViewController , CallDelegate{
    @IBOutlet var tableView: UITableView!
    var patientsListViewModel = PatientsListViewModel()
   
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    var agoraKit :AgoraRtcEngineKit!
    var rtmChannel: AgoraRtmChannel?
    var peerId:String?
    var rtmKit :AgoraRtmKit?
    var callObsever:Any?

    var remoteVC :SelectRemoteViewController?
    
    var updateUser:String?
    
    @IBOutlet weak var mutePatient: UIButton!
    @IBOutlet weak var muteClinic: UIButton!
    @IBOutlet weak var hidePatiet: UIButton!
    @IBOutlet weak var hideCliic: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        self.setupRtm()
        
        bind(model: patientsListViewModel)
        patientsListViewModel.fetchPatients {
            
        }
        
        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)
        searchBar.textField?.font = FontStyle.normal.apply()
        
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!
        ]
        
        let font = UIFont.systemFont(ofSize: 20)

        navigationItem.title = "PATIENTS"
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeAction))
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        containerController()?.selectedVCIndex.asObservable().subscribe(onNext: { [weak self] index in
            if index == 0 {
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self?.saveAction))
                
                self?.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            }
            else {
                self?.navigationItem.rightBarButtonItem = nil
            }
        }).disposed(by: disposeBag)
        
        containerController()?.didAddNewPatient.asObservable().subscribe(onNext: { [weak self] didAdd in
            if didAdd == true {
                if AgoraRtm.rtmChannel == nil{
                    self?.patientsListViewModel.fetchPatients {}
                    self?.containerController()?.clearPatientInfo()
                    self?.containerController()?.view.endEditing(true)
                    self?.addEmptyViewToTableFooter()
                }else{
                    self?.patientsListViewModel.fetchPatients {
                        if let fetchedPatient = self?.patientsListViewModel.searchPatient(text: self?.updateUser ?? ""){
                            self?.containerController()?.show(patient: fetchedPatient, isExisting: true)
                        }
                    }
                    
                    
                    
                }
                
            }
        }).disposed(by: disposeBag)
        
        containerController()?.didUpdatePatient
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] patientInfo in
                guard let patientInfo = patientInfo else { return }
                if let index = self?.patientsListViewModel.update(patientInfo: patientInfo) {
                    self?.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
                }
                self?.containerController()?.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        containerController()?.didDeletePatient
        .asObservable()
        .skip(1)
        .subscribe(onNext: { [weak self] succ in
            if succ == true {
                self?.patientsListViewModel.fetchPatients {}
                self?.containerController()?.clearPatientInfo()
                self?.containerController()?.view.endEditing(true)
            } else {
                self?.notiMessage("Failed to delete the patient.")
            }
        }).disposed(by: disposeBag)
    }
    
    func setupRtm(){
        if let rtmChannel = rtmChannel{
            AgoraRtm.rtmChannel = rtmChannel
            initializeAgoraEngine()
            self.videoView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if rtmChannel != nil{
            self.rtmChannel?.channelDelegate = self
            self.rtmChannel?.send(AgoraRtmMessage(text: MessageHandling.stopAudio), completion: { (errorCode) in
                
            })
            if AgoraKit.myUID != nil {
                
                AgoraKit.setupLocalVideo(self.localView, uid: AgoraKit.myUID)
                if AgoraKit.opponentUID != nil{
                    AgoraKit.setupRemoteView(withRemoteView: self.remoteView, uid: AgoraKit.opponentUID)
                }
                
                self.updateButton()
                
            }
            
        }
    }
    
    func updateButton() {
        self.remoteView.alpha = AgoraRtm.hideRemote == true ? 0 : 1
        hideCliic.isSelected = AgoraRtm.hideLocal
        hidePatiet.isSelected = AgoraRtm.hideRemote
        muteClinic.isSelected = AgoraRtm.muteClinic
        mutePatient.isSelected = AgoraRtm.mutePatient
    }
    
    @objc func recieveCall(_ notification:Notification){
        if let val = self.containerController()?.navigationController?.topViewController?.isKind(of: PatientsViewController.self), val == true{
            remoteVC = SelectRemoteViewController.viewController
            if let channel = notification.object as? AgoraRtmChannel{
                remoteVC?.channel = channel
            }
            remoteVC?.showViewForParent(self)
            remoteVC?.callDelegate = self
            
            if let not = notification.object as? AgoraRtmChannel{
                self.rtmChannel = not
            }
        }
        
    }
    func cancelTapped(){
        self.rtmChannel = nil
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
                            self?.rtmChannel = rtmChannel
                            DispatchQueue.main.async {
                                self?.setupRtm()
                                self?.remoteVC?.hideView()
                            }
                            
                        }
                    }
                })
            }
        })
    }
    
    deinit {
        if let call = callObsever{
            NotificationCenter.default.removeObserver(call)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        User.current?.getProfile()
    }
    
    @objc func saveAction() {
        containerController()?.saveAction()
    }
    
    private func addNewPatientLabelToTableFooter() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 45))
        label.font = FontStyle.normal.apply()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "New Patient"
        label.backgroundColor = ColorStyle.semiTransparentBlue.color
        tableView.tableFooterView = label
    }
    
    private func addEmptyViewToTableFooter() {
        tableView.tableFooterView = UIView()
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
        self.leaveChannel()
    }
    
    @IBAction func addNewPatientAction() {
        guard let contianer = self.containerController() else {
            return
        }
        guard contianer.containsPatientInfo() == false else {
            askUserToChangePatient(patient: nil, indexPath: nil, wasChange: {[weak self] in
                guard let `self` = self else { return }
                self.addNewPatientLabelToTableFooter()
                self.continueCreateNewPatient()
                self.tableView.scrollRectToVisible(self.tableView.tableFooterView!.frame, animated: true)

            })
            return
        }
        addNewPatientLabelToTableFooter()
        continueCreateNewPatient()
        tableView.scrollRectToVisible(tableView.tableFooterView!.frame, animated: true)
    }
    
    private func askUserToChangePatient(patient: PatientInfo?, indexPath: IndexPath?, wasChange: (() -> ())? = nil) {
        guard let contianer = self.containerController() else {
            return
        }
        let changePatientAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            contianer.show(patient: patient)
            if let indexPath = indexPath {
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    cell.isSelected = true
                }
                self.patientsListViewModel.fetchPatients {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
                
            }
            wasChange?()
        })
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        self.showAlert(title: "Warning!",
                        message: "Are you sure you would like to access a different patient record?",
                        actions: [changePatientAction, cancelAction],
                        preferredStyle: .alert)
    }
    
    private func continueCreateNewPatient() {
        if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows {
            for indexPath in indexPathsForVisibleRows {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        containerController()?.clearPatientInfo()
        containerController()?.unlockOnlyInformationScreen()
    }
    
    private func containerController() -> PatientsInfoContainerViewController? {
        let res = children.first        
        return res as? PatientsInfoContainerViewController
    }
    
    class var viewController: PatientsViewController {
        let storyboard = UIStoryboard(name: "Patients", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "PatientsViewController") as! PatientsViewController
    }
    
    // MARK: - private
    private func notiMessage(_ mess: String) {
        showAlert(title: "Notification", message: mess, buttonTitle: "OK")
    }
    
    @IBAction func switchCamera(_ sender:UIButton){
        agoraKit.switchCamera()
    }
    
    @IBAction func mutePatient(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            AgoraRtm.mutePatient = true
            self.sendRTMMessage(AgoraRtmMessage(text: MessageHandling.mutePatient))
        }else{
            self.sendRTMMessage(AgoraRtmMessage(text: MessageHandling.unmutePatient))
            AgoraRtm.mutePatient = false
        }
    }
    @IBAction func muteClinic(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            AgoraRtm.muteClinic = true
            self.agoraKit.muteLocalAudioStream(true)
        }else{
            self.agoraKit.muteLocalAudioStream(false)
            AgoraRtm.muteClinic = false
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
            AgoraRtm.hideLocal = true
            self.sendRTMMessage(AgoraRtmMessage(text: MessageHandling.hideClinicCamera))
        }else{
            AgoraRtm.hideLocal = false
            self.sendRTMMessage(AgoraRtmMessage(text: MessageHandling.unhideClinicCamera))
        }
    }
    
    

}
    // MARK: - ext
extension PatientsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        patientsListViewModel.searchPatients(text: searchText)
    }
}

extension PatientsViewController: Bindable {
    func bind(model: PatientsListViewModel) {
        model.patients.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: BaseAudiometerCell.self)) {[weak self] _, patient, cell in
            cell.textLabel?.text = patient.fullName
            cell.needManualHandleTap = true
                        
            cell.manualTapHandler = { [weak cell] in
                guard let cell = cell else { return }
                if let indexPath = self?.tableView.indexPath(for: cell), let contianer = self?.containerController()  {
                    guard contianer.containsPatientInfo() == true else {
                        let patient = model.patients.value[indexPath.row]
                        contianer.show(patient: patient)
                        cell.isSelected = true
                        self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        self?.addEmptyViewToTableFooter()
                        return
                    }
                    guard cell.isSelected == false else  { return }
                    let patient = model.patients.value[indexPath.row]
                    self?.askUserToChangePatient(patient: patient, indexPath: indexPath, wasChange: {
                        self?.addEmptyViewToTableFooter()
                    })
                }
            }
        }.disposed(by: self.disposeBag)
        
        model.loading.asObservable().subscribe(onNext: { [weak self] loading in
            if loading {
                self?.showProgressHUD()
            }
            else {
                self?.hideProgressHUD()
            }
        }).disposed(by: disposeBag)
        
        // TODO: show error fetching patients
    }
}

extension UISearchBar {

    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            // Fallback on earlier versions
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}

extension PatientsViewController:AgoraRtcEngineDelegate{
    
    func initializeAgoraEngine() {
        // init AgoraRtcEngineKit
        agoraKit =  AgoraRtcEngineKit.sharedEngine(withAppId: AppId.id, delegate: self)
        AgoraKit.kit = agoraKit
        
        
        rtmChannel?.channelDelegate = self
        AgoraKit.joinChannel(withChannelName: AgoraKit.channelId) { (channelid, uid, elapsed) in
                DispatchQueue.main.async {
                    UIApplication.shared.isIdleTimerDisabled = true
                    AgoraKit.setupLocalVideo(self.localView, uid: uid)
                }
            }
        
        
    }
    
    
    
    func leaveChannel() {
        // leave channel and end chat
        if agoraKit != nil {
            AgoraKit.leaveChannel()
        }
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func sendRTMMessage(_ message:AgoraRtmMessage){
        self.rtmChannel?.send(message, completion: { (errorCode) in
            
        })
    }
    
    func sendMessage(_ message:AgoraRtmRawMessage){
        self.rtmChannel?.send(message, completion: { (errorCode) in
            
        })
    }

    // first remote video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        DispatchQueue.main.async {
            AgoraKit.setupRemoteView(withRemoteView: self.remoteView, uid: uid)
        }
        
        AgoraKit.opponentUID = uid
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState, reason: AgoraVideoRemoteStateReason, elapsed: Int) {
        DispatchQueue.main.async {
            AgoraKit.setupRemoteView(withRemoteView: self.remoteView, uid: uid)
        }
        AgoraKit.opponentUID = uid
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("Did occur warning \(warningCode)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Did occur error \(errorCode)")
    }
    
}
extension PatientsViewController:AgoraRtmChannelDelegate, AgoraRtmDelegate{
    
     func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        if self.peerId == peerId{
            switch message.type {
                case .text: break
                case .raw:
                    if let rawMessage = message as? AgoraRtmRawMessage{
                        if let userfield = UserFields.decode(fromData: rawMessage.rawData){
                            let patient = Patient(id: nil, genderValue: Genders.m, email: userfield.email, mailingAddress_1: nil, mailingAddress_2: nil, city: nil, state: nil, zip: nil, phoneNumber: nil, dateOfBirth: nil, lastName: userfield.lastName, firstName: userfield.firstName, socialSecurityNumber: nil, insurance: nil, patientId: nil, icd_9: [], icd_10: [])
                            
                            containerController()?.show(patient: patient)
                            self.sendMessage(AgoraRtmRawMessage(text: MessageHandling.receiveName))
                        }
                        
                    }
                    
                    break
                default:break
            }
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        
        switch message.type {
        case .text:
            switch message.text {
            case MessageHandling.mutePatient:
                self.mutePatient.isSelected = true
                AgoraRtm.mutePatient = true
            case MessageHandling.unmutePatient :
                self.mutePatient.isSelected = false
                AgoraRtm.mutePatient = false
            default:break
                
            }
            
            
            break
        case .raw:
            if let rawMessage = message as? AgoraRtmRawMessage{
                if let userfield = UserFields.decode(fromData: rawMessage.rawData){
                    let patient = Patient(id: nil, genderValue: Genders.m, email: userfield.email, mailingAddress_1: nil, mailingAddress_2: nil, city: nil, state: nil, zip: nil, phoneNumber: nil, dateOfBirth: nil, lastName: userfield.lastName, firstName: userfield.firstName, socialSecurityNumber: nil, insurance: nil, patientId: nil, icd_9: [], icd_10: [])
                    
                    updateUser = userfield.firstName + " " + userfield.lastName
                    if let fetchedPatient = patientsListViewModel.searchPatient(text: self.updateUser ?? ""){
                        containerController()?.show(patient: fetchedPatient, isExisting: true)
                    }else{
                        containerController()?.show(patient: patient)
                    }
                    self.sendMessage(AgoraRtmRawMessage(text: MessageHandling.receiveName))
                }
                
            }
            
            break
        default:break
        }
    }
    
    // Receive one to one offline messages
    
    
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        print(channel)
        if member.userId.contains("patient"){
            
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        if let patientName = AgoraKit.patientName{
            if member.userId == patientName{
                let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                    self.leaveChannel()
                    self.updateUser = nil
                    DispatchQueue.main.async {
                        self.closeAction()
                    }
                }
                DispatchQueue.main.async {
                    self.showAlert(title: "Alert", message: "Patient got disconnected, please wait he will connect with you again.", actions: [action], preferredStyle: .alert)
                }
                
            }
        }
        
        
    }
    
}
