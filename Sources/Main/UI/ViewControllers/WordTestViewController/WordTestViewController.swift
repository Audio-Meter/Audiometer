//
//  WordTestViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/28/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import LGButton
import RxSwift
import RxCocoa
import MBProgressHUD
import AgoraRtcKit
import AgoraRtmKit

class WordTestViewController: BaseViewController,CallDelegate {
    @IBOutlet var amplitudeLabel: UILabel!
    @IBOutlet var transducerPlace: UILabel!
    
    var peerID:String?
    var rtmKit: AgoraRtmKit?
   
    @IBOutlet var play: LGButton!
    @IBOutlet var save: LGButton!
    let lnrItems = ["L","R","Binaural"]

    @IBOutlet var settings: WordSettingsView!
    
    @IBOutlet var masking: WordMaskingView!
    
    @IBOutlet var player: WordPlayerView!

    @IBOutlet var playedCount: UILabel!
    @IBOutlet var correctCount: UILabel!

    @IBOutlet weak var localremoteViewCostrait: NSLayoutConstraint!
    @IBOutlet var clear: UIButton!
    @IBOutlet var correct: UIButton!
    @IBOutlet var wrong: UIButton!
    @IBOutlet var skip: UIButton!
    @IBOutlet var score: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    @IBOutlet var mcl: UIButton!
    @IBOutlet var ucl: UIButton!
    
    @IBOutlet var sync: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    var categoryPicker: UIPickerView!
    
    @IBOutlet var result: WordTestResultView!

    @IBOutlet var export: LGButton!
    @IBOutlet var bottomBar: UIView!
    
    var agoraKit :AgoraRtcEngineKit!
    var rtmChannel: AgoraRtmChannel?
    
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet var localView: UIView!
    @IBOutlet var remoteView: UIView!
    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet weak var localRemoteView: UIView!
    var modelTest:WordTestPage?

    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?
    var previousHeight:CGFloat!

    @IBOutlet weak var earChnelCollectionView: UICollectionView!

    let conductionItems = ["Air", "Bone", "Soundfield"]
    @IBOutlet weak var ConductionCollection: UICollectionView!
    
    @IBOutlet weak var PerformasCollectionView: UICollectionView!
    
    
    @IBOutlet weak var MaskingTypeCollectionView: UICollectionView!
    
    @IBOutlet weak var mutePatient: UIButton!
    @IBOutlet weak var muteClinic: UIButton!
    @IBOutlet weak var hidePatiet: UIButton!
    @IBOutlet weak var hideCliic: UIButton!
    
    var categoryDialog: UIAlertController!
//    let talkController = TalkViewController()
    let amplitudeController = SteppedViewController()
    let transducerController = TransducerPickerController()
    var model: WordTestPage!
    var storage: Storage!

    var conductionIndexPath = IndexPath(row: 0, section: 0)
    var earIndexpath:[IndexPath] = [IndexPath(row: 0, section: 0)]
    var performanceIndexPath = IndexPath(row: 0, section: 0)
    var typeIndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var collectionviewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        storage = Storage(storage: appDelegate.persistentContainer)
        
        setupRtm()
        let font = UIFont.systemFont(ofSize: 20)
        let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
               
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SpeechHistory))

        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

        amplitudeController.attach(to: amplitudeLabel)
        amplitudeController.type.removeBorders()
        amplitudeController.type.layer.cornerRadius = 15
        amplitudeController.type.layer.borderWidth = 1
        amplitudeController.type.clipsToBounds = true
        transducerController.attach(to: transducerPlace)
//        talkController.attach(to: bottomBar)
        callObsever = NotificationCenter.default.addObserver(self, selector: #selector(recieveCall), name: NSNotification.Name.receiveCall, object: nil)
        
        self.navigationController?.navigationBar.backItem?.title = "Back"
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
            NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
        }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        earChnelCollectionView.setNeedsLayout()
        earChnelCollectionView.layoutIfNeeded()
        self.earChnelCollectionView.reloadData()
       
        
        ConductionCollection.setNeedsLayout()
        ConductionCollection.layoutIfNeeded()
        self.ConductionCollection.reloadData()
       
        
        
        
    PerformasCollectionView.setNeedsLayout()
    PerformasCollectionView.layoutIfNeeded()
    self.PerformasCollectionView.reloadData()
        
        
        
    MaskingTypeCollectionView.setNeedsLayout()
    MaskingTypeCollectionView.layoutIfNeeded()
    self.MaskingTypeCollectionView.reloadData()
        if AgoraRtm.rtmChannel != nil{
            self.view.bringSubviewToFront(self.videoView)
            self.videoView.isHidden = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    func setupRtm(){
            if let channel = AgoraRtm.rtmChannel{
                self.rtmChannel = channel
                self.rtmChannel?.channelDelegate = self
                agoraKit = AgoraKit.kit
                AgoraKit.updateKit(delegate: self)
                self.setupVideoView()
                
                self.sendMessage(AgoraRtmMessage(text:MessageHandling.speechTest))                
            }
        }
    
    func setupVideoView(){
        videoView.frame = CGRect(x: 16, y: 16, width: 300, height: UIScreen.main.bounds.height - 150)
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

    func sendMessage(_ message:AgoraRtmMessage){
        self.rtmChannel?.send(message, completion: { (errorCode) in
            
        })
    }
    
    func sendMessage(_ rawMessage:AgoraRtmRawMessage){
        self.rtmChannel?.send(rawMessage, completion: { (errorCode) in
            
        })
    }
    
    
    
@objc func SpeechHistory()
   {
    var viewModel = testinfo.getTheviewmodel()
                   
    TestsRouter.showPreviousTests(type: Tests(rawValue: "speech")!, patient: viewModel.patientInfo, from: self, report: viewModel.report)
   }

}


extension WordTestViewController: Bindable {
    func bind(model: WordTestPage) {
        self.model = model
        amplitudeController.bind(model: model.amplitudeModel)
        transducerController.bind(model: model.transducerModel)
//        talkController.bind()

        if AgoraRtm.rtmChannel != nil{
            self.modelTest = model
            model.playedVar.asObservable().subscribe({ (maskConfig) in
                if  let val = maskConfig.element.value{
                    if val{
                        print("Play")
                        self.sendMessage(AgoraRtmMessage(text: MessageHandling.playSpeechTest))
                    }else{
                        print("stop")
                        self.sendMessage(AgoraRtmMessage(text: MessageHandling.stopSpeechTest))
                    }
                }
            }).disposed(by: disposeBag)
        }
        
        model.playButton ||> play ||> disposeBag
        
        

        settings.bind(model: model.conductionIdea)
        
        masking.bind(model: model.masking)
        settings.bind(model: model.player)
        player.bind(model: model.player)
        result.bind(model: model.result)

        play.rx.tap ||> model.pause2 ||> disposeBag
        model.player.didStopped ||> model.pause ||> disposeBag
        
        
        

        model.player.isPlaying ||> skip.rx.isEnabled ||> disposeBag
        setUpCategoryDialog()
        clear.rx.tap ||> model.zeroStat ||> model.wordStat ||> disposeBag
        categoryPicker.rx.itemSelected
            .subscribe { (event) in
                switch event {
                case .next(let selected):
                    model.player.currentCategoryIndex.value = selected.row
                default:
                    break
                }
            } ||> disposeBag
        model.player.currentCategoryIndex.asObservable().subscribe(onNext: { [weak self] (value) in
            self?.categoryButton.setTitle("Select Word List".uppercased(), for: .normal)
        }) ||> disposeBag

        model.category.bind(to: categoryPicker.rx.itemTitles) { (row, element) in
            return element
        } ||> disposeBag

        correct.rx.tap.subscribe({ [weak self] selected in
            guard let `self` = self else { return }
            model.markAsCorrect(file: self.player.player.currentPlayingFile)
        }).disposed(by: disposeBag)

        categoryButton.rx.tap ||> { [weak self] in
            self?.showCategoryDialog()
        } ||> disposeBag

        wrong.rx.tap.subscribe({ [weak self] selected in
            guard let `self` = self else { return }
            model.wrong(file: self.player.player.currentPlayingFile)
        }).disposed(by: disposeBag)

        model.player.didStopped ||> model.zeroStat ||> model.wordStat ||> disposeBag
        score.rx.tap ||> model.score ||> disposeBag
        reset.rx.tap ||> model.reset ||> disposeBag

        model.mclComfortLevelSelected.asObservable().subscribe(onNext: { [weak self] selected in
            self?.configure(button: self?.mcl, selected: selected)
        }).disposed(by: disposeBag)

        model.uclComfortLevelSelected.asObservable().subscribe(onNext: { [weak self] selected in
            self?.configure(button: self?.ucl, selected: selected)
        }).disposed(by: disposeBag)

        model.playedCount ||> playedCount.rx.text ||> disposeBag
        model.correctCount ||> correctCount.rx.text ||> disposeBag

        mcl.rx.tap ||> { .mcl } ||> model.comfortLevel ||> disposeBag
        ucl.rx.tap ||> { .ucl } ||> model.comfortLevel ||> disposeBag
        
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        let channels = Observable.just(lnrItems)
        let conductionModel = model.conductionIdea

                channels
                    .bind(to: self.earChnelCollectionView.rx.items) { (collectionView, row, element) in
                   let indexPath = IndexPath(row: row, section: 0)
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                        cell.subTitle.text = "\(element)"
                        if self.earIndexpath.contains(indexPath){
                            cell.selectedImage.image = UIImage(named: "01")
                        }else{
                            cell.selectedImage.image = UIImage(named: "02")
                        }
                    
                    return cell
                }.disposed(by: disposeBag)
        
        earChnelCollectionView.rx.itemSelected.asObservable().subscribe { (event) in
            if let item = event.element{
                self.earIndexpath.removeAll()
                self.earIndexpath.append(item)
                conductionModel.conductionIndexPath.value.removeAll()
                conductionModel.conductionIndexPath.value.append(item)            
                self.earChnelCollectionView.reloadData()
            }
            
        }.disposed(by: disposeBag)
        
        conductionModel.type ||> disposeBag
              
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        
        let items = Observable.just(conductionItems)
        items
            .bind(to: self.ConductionCollection.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.conductionIndexPath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        ConductionCollection.rx.itemSelected.bind(to: conductionModel.conductionIndexPathTone).disposed(by: disposeBag)
         
        conductionModel.conductionIndexPathTone.asObservable().subscribe { (event) in
            if let item = event.element{
                self.conductionIndexPath = item
                self.ConductionCollection.reloadData()
            }
        }.disposed(by: disposeBag)

        
        
        
        
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let chennelstype = Observable.just(["SRT","SD"])
        
       
                chennelstype
                    .bind(to: self.PerformasCollectionView.rx.items) { (collectionView, row, element) in
                   let indexPath = IndexPath(row: row, section: 0)
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                        
                        cell.subTitle.text = "\(element)"
                        cell.selectedImage.image = indexPath == self.performanceIndexPath ? UIImage(named: "01") : UIImage(named: "02")
                    
                    return cell
                }.disposed(by: disposeBag)
        
        PerformasCollectionView.rx.itemSelected.bind(to: model.player.srtSdType).disposed(by: disposeBag)
        model.player.typeVariable ||> disposeBag
        
        PerformasCollectionView.rx.itemSelected.asObservable().subscribe { (event) in
                          if let item = event.element{
                            self.performanceIndexPath = item
                        self.PerformasCollectionView.reloadData()
                    }
            }.disposed(by: disposeBag)
        
       
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
        
  
        let MaskChannel = Observable.just(["WN","NBN","PN","SN"])
        MaskChannel
            .bind(to: self.MaskingTypeCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.typeIndexPath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        MaskingTypeCollectionView.rx.itemSelected.bind(to: model.masking.typeIndexPath).disposed(by: disposeBag)
        model.masking.typeVariable ||> disposeBag
        
        model.masking.typeIndexPath.asObservable().subscribe { (event) in
            if let item = event.element{
                self.typeIndexPath = item
                self.MaskingTypeCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//        sync.rx.tap ||> { [weak self] in self?.syncAudio() } ||> disposeBag

        let audio = AudioManager(players: masking.player,  player.player)
        self ||> audio ||> disposeBag

        save.rx.tap ||> model.testResultPage ||> { [weak self] (testResultPage: TestResultPage<WordTestResult>) in
            guard let `self` = self else { return }
            // TODO: probably need to add loading property to model and observe it
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            testResultPage.save(with: self.result.asImage()).subscribe(onNext: { [weak self] (success) in
                if success {
                    self?.navigator.back()
                }
                }, onError: { [weak self] (error) in
                    self?.showAlert(error: error)
                }, onDisposed: {
                    hud.hide(animated: true)
            }).disposed(by: self.disposeBag)
            } ||> disposeBag
        
        self.syncAudio()
    }
    
    func setUpCategoryDialog() {
        let message = "\n\n\n\n\n\n"
        categoryDialog = UIAlertController(title: "Please Select Category", message: message, preferredStyle: UIAlertController.Style.alert)

        categoryDialog.isModalInPopover = true
        categoryPicker = UIPickerView(frame: CGRect(x: 0, y: 20, width: 200, height: 140))
        
        categoryPicker.center.x = 130
        categoryPicker.tag = 555
        
        categoryDialog.view.addSubview(categoryPicker)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        categoryDialog.addAction(okAction)
    }
    
    func showCategoryDialog() {
        self.parent!.present(categoryDialog, animated: true, completion: nil)
    }
    
    private func syncAudio() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "loading..."
        model.syncAudio { [weak self] (error) in
            guard let `self` = self else { return }
            hud.hide(animated: true)
            guard error == nil else {
                self.showAlert(error: error!)
                return
            }
            self.player.resetDisposeBag()
            self.player.bind(model: self.model.player)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.sendMessage(AgoraRtmMessage(text:MessageHandling.stopAudio))
        }
       syncAudio()
    }

    
    private func configure(button: UIButton?, selected: Bool) {
        guard let button = button else {
            return
        }
        button.isSelected = selected

        if selected {
            var buttonStyle = Styles.button.Cleared()
            button.setImage(UIImage(named: "01"), for: .normal)
            buttonStyle.apply(to: button)
        }
        else {
            var buttonStyle = Styles.button.Cleared()
           button.setImage(UIImage(named: "02"), for: .normal)
            buttonStyle.apply(to: button)
        }
    }
    
    class var viewController: WordTestViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "wordTest") as! WordTestViewController
    }
}

extension WordTestPage: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController(page: self) as WordTestViewController
    }
}
extension WordTestViewController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width:CGFloat = 48
        if collectionView == earChnelCollectionView{
            width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 15), text: lnrItems[indexPath.row]) + 16
            if width < 49{
                return CGSize(width: 50, height: 65)
            }
            return CGSize(width: width, height: 65)
        } else if collectionView == PerformasCollectionView{
            return CGSize(width: 70, height: 60)
        }else if collectionView == ConductionCollection{
            width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 15), text: conductionItems[indexPath.row]) + 16
            if width < 49{
                return CGSize(width: 50, height: 60)
            }
            return CGSize(width: width, height: 60)
        }else if collectionView == MaskingTypeCollectionView {            
            return CGSize(width: 210/4 , height: 55)
        }
//
        return CGSize(width: 75, height: 70)
    }
    
}

extension WordTestViewController : AgoraRtmChannelDelegate{
        
        func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
            
            switch message.type {
            case .text:
                switch message.text {
                case MessageHandling.heardIt:
                    self.modelTest?.playedVar.value = false
                        
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

extension WordTestViewController:AgoraRtcEngineDelegate{
    
}
