//
//  CalibrationViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import LGButton
import RxSwift
import RxCocoa
import AgoraRtmKit

class CalibrationViewController: BaseViewController, CallDelegate {
    @IBOutlet var type: UISegmentedControl!
    @IBOutlet var pan: ChannelsView!
    @IBOutlet var frequency: UISegmentedControl!

    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var stepCollectionView: UICollectionView!
    @IBOutlet weak var frequencyCollectionView: UICollectionView!
    @IBOutlet weak var lnrCollectionView: UICollectionView!
    
    @IBOutlet var step: UISegmentedControl!
    @IBOutlet var increment: UIButton!
    @IBOutlet var decrement: UIButton!

    @IBOutlet var play: LGButton!
    @IBOutlet var save: LGButton!
    @IBOutlet var restore: LGButton!

    @IBOutlet var transducerPlace: UILabel!

    let tonePlayer = TonePlayer()
    let wordPlayer = WordPlayer()
    let noisePlayer = MaskingPlayer()
    var callObsever:Any?
    var remoteVC:SelectRemoteViewController?

    let transducerController = TransducerPickerController()

    @IBOutlet weak var lblVersion: UILabel!
    var typeIndexpath: IndexPath = IndexPath(row: 0, section: 0)
    var lrIndexpath: [IndexPath] = [IndexPath(row: 0, section: 0)]
    var frequencyIndexpath: IndexPath = IndexPath(row: 0, section: 0)
    var stepIndexpath: IndexPath = IndexPath(row: 0, section: 0)
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.isFromCalibration = true
        
        
        
        transducerController.attach(to: transducerPlace)
        
          let font = UIFont.systemFont(ofSize: 20)
         let attrs = [
                    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!
                ]
        
         UINavigationBar.appearance().titleTextAttributes = attrs
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeAction))
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            lblVersion.text = "Version: \(appVersion)\n"
            
        }
        
        if let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String {
            lblVersion.text = lblVersion.text! + "Build: \(bundleVersion)"
            
        }
        //let image = UIImage(named:"ringSelected.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

        //self.type.setBackgroundImage(image, for: .selected, barMetrics: .default)
        //self.type.backgroundImage(for: .selected, barMetrics: .default)
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
        self.closeAction()
        NotificationCenter.default.post(name: Notification.Name.startCall, object: nil)
    }
    
    @objc func closeAction() {
        if let navigationController = self.navigationController {
            navigationController.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    class var viewController: CalibrationViewController {
        let storyboard = UIStoryboard.mainStoryboard
        return storyboard.instantiateViewController(withIdentifier: "calibration") as! CalibrationViewController
    }
}

extension CalibrationViewController: Bindable {
    func bind(model: CalibrationPage) {
//        pan.bind(model: model.conductionIdea)
        transducerController.bind(model: model.transducerModel)
        
        
        
        frequency.titles = model.frequencies
        
        let items = Observable.just(model.types)
        items
            .bind(to: self.typeCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.typeIndexpath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        typeCollectionView
            .rx.itemSelected.bind(to: model.typeIndex).disposed(by: disposeBag)
         
        model.typeIndex.asObservable().subscribe { (event) in
            if let item = event.element{
                self.typeIndexpath = item
                self.typeCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
//        type.rx.value <||> model.typeIndex ||> disposeBag
//        frequency.rx.value <||> model.frequencyIndex ||> disposeBag
//        step.rx.value <||> model.stepIndex ||> disposeBag
        
        let frequencies = Observable.just(model.frequencies)
        frequencies
            .bind(to: self.frequencyCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.frequencyIndexpath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        frequencyCollectionView
            .rx.itemSelected.bind(to: model.frequencyIndex).disposed(by: disposeBag)
        
        model.frequencyIndex.asObservable().subscribe { (event) in
            if let item = event.element{
                self.frequencyIndexpath = item
                self.frequencyCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
        
        let steps = Observable.just(model.steps)
        steps
            .bind(to: self.stepCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = "\(element)"
                cell.selectedImage.image = indexPath == self.stepIndexpath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        stepCollectionView
            .rx.itemSelected.bind(to: model.stepIndex).disposed(by: disposeBag)
        
        model.stepIndex.asObservable().subscribe { (event) in
            if let item = event.element{
                self.stepIndexpath = item
                self.stepCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)

        let conductionModel = model.conductionIdea
        
        let channels = Observable.just(["L","R"])
       
        channels
            .bind(to: self.lnrCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                if self.lrIndexpath.contains(indexPath){
                    cell.selectedImage.image = UIImage(named: "01")
                }else{
                    cell.selectedImage.image = UIImage(named: "02")
                }
            return cell
        }.disposed(by: disposeBag)
        
        lnrCollectionView.rx.itemSelected.asObservable().subscribe { (event) in
            if let item = event.element{
                if self.lrIndexpath.filter({ $0.row == item.row}).count == 0{
                    self.lrIndexpath.append(item)
                    conductionModel.conductionIndexPath.value.append(item)
                }else if self.lrIndexpath.count > 1, let index = self.lrIndexpath.index(of: item){
                    self.lrIndexpath.remove(at: index)
                    conductionModel.conductionIndexPath.value.remove(at: index)
                }
                   self.lnrCollectionView.reloadData()
            }
            
        }.disposed(by: disposeBag)
        
        
        conductionModel.type ||> disposeBag
            
        
    
            
        model.isFrequencyEnabled ||> frequencyCollectionView.rx.isUserInteractionEnabled ||> disposeBag
        model.frequencyDidDisabled ||> model.setDefaultFrequency ||> disposeBag
        model.isFrequencyEnabled.asObservable().subscribe { (success) in
            if let item = success.element {
                self.frequencyCollectionView.alpha = item == true ? 1.0 : 0.5
            }
        }.disposed(by: disposeBag)
        
        

        
        
         

        increment.rx.tap ||> model.increment ||> model.put ||> disposeBag
        decrement.rx.tap ||> model.decrement ||> model.put ||> disposeBag

        
                
        
        
        
        

        let audio = AudioManager(players: tonePlayer, wordPlayer, noisePlayer)
        self ||> audio ||> disposeBag
        model.isTonePlaying ||> tonePlayer.played ||> disposeBag //TODO: Kill me
        model.toneConfigs ||> tonePlayer.settings ||> disposeBag
        model.wordConfigs ||> wordPlayer ||> disposeBag //10th Jan Change for new speech
        model.noiseConfigs ||> noisePlayer.rx.config ||> disposeBag

        play.rx.tap ||> model.play.toggle ||> disposeBag
        model.play.styles ||> play ||> disposeBag

        model.loadedCalibration ||> model.calibration ||> disposeBag
        save.rx.tap ||> model.save ||> disposeBag
        restore.rx.tap ||> model.restore ||> disposeBag

//        navigationItem.leftBarButtonItem!.rx.tap ||> model.save ||> disposeBag
        navigationItem.leftBarButtonItem!.rx.tap ||> { [weak self] in self?.closeAction() } ||> disposeBag
 
    }
}

extension CalibrationPage: PageViewModel {
    func createController(router: Router) -> UIViewController {
        return router.createController(page: self) as CalibrationViewController
    }
}

extension CalibrationViewController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == frequencyCollectionView {
            let totalCount = CGFloat(frequencyCollectionView.numberOfItems(inSection: 0))
            let width:CGFloat = (UIScreen.main.bounds.width - 50) / totalCount
            return CGSize(width: width, height: 92)
        }else if collectionView == typeCollectionView{
            let totalCount = CGFloat(6)
            let width = (typeCollectionView.frame.width + 10)/totalCount
            return CGSize(width: width - 10 , height: 92)
        }
        
        return CGSize(width: 75, height: 92)
    }
    
}
