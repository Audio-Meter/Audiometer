//
//  ToneSettingsView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/26/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import AgoraRtmKit

class ToneSettingsView: UIView {
    let disposeBag = DisposeBag()
    
    private let flowLayout = UICollectionViewFlowLayout()
    

    let boxLabel = UILabel()
    let channelLabel = UILabel()
    let channelControl = ChannelsView()
    let lnrItems = ["L","R","Binaural"]
    var lnrCollectionView:UICollectionView! = nil
    var lrIndexpath: [IndexPath] = [IndexPath(row: 0, section: 0)]

    let conductionLabel = UILabel()
    let conductionControl = UISegmentedControl()
    let conductionCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var conductionIndexPath = IndexPath(row: 0, section: 0)
    let conductionItems = ["Air", "Bone", "Soundfield"]

    let typeLabel = UILabel()
    let typeControl = UISegmentedControl()
    let typeItems = ["Steady", "Warble", "Pulsed"]
    let typeCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var typeIndexPath = IndexPath(row: 0, section: 0)

    
    let pulseLabel = UILabel()
    let pulseControl = UISegmentedControl()
    let pulseItems = ["200ms", "500ms", "1s"]
    let pulseCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var pulseIndexPath = IndexPath(row: 0, section: 0)

    let frequencyLabel = UILabel()
    let frequencyControl = UISegmentedControl()
    let frequencyItems = ["5Hz", "10Hz", "20Hz"]
    let frequencyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var frequencyIndexPath = IndexPath(row: 0, section: 0)

    let modulationLabel = UILabel()
    let modulationControl = UISegmentedControl()
    let modulationItems = ["5%", "10%", "20%"]
    let modulationCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var modulationIndexPath = IndexPath(row: 0, section: 0)
    let player = TonePlayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionViews()
        styleViews()
    }
    // 75, 134, 180
    
    func styleCollectionView(_ collectionView:UICollectionView){
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.cornerRadius = 8
        collectionView.borderWidth = 2
        collectionView.borderColor = UIColor(red: 75.0/255.0, green: 134.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        
//        collectionView.delegate = self
//        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
    
    func setupCollectionViews(){
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        lnrCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        lnrCollectionView.delegate = self
        conductionCollectionView.delegate = self
        typeCollectionView.delegate = self
        pulseCollectionView.delegate = self
        frequencyCollectionView.delegate = self
        modulationCollectionView.delegate = self
        
        addSubview(lnrCollectionView)
        addSubview(conductionCollectionView)
        addSubview(typeCollectionView)
        addSubview(pulseCollectionView)
        addSubview(frequencyCollectionView)
        addSubview(modulationCollectionView)
        registerNibs()
    }
    
    func registerNibs(){
        lnrCollectionView.register(UINib(nibName: "CalibrationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalibrationCollectionViewCell")
        
        conductionCollectionView.register(UINib(nibName: "CalibrationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalibrationCollectionViewCell")
        typeCollectionView.register(UINib(nibName: "CalibrationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalibrationCollectionViewCell")
        pulseCollectionView.register(UINib(nibName: "CalibrationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalibrationCollectionViewCell")
        frequencyCollectionView.register(UINib(nibName: "CalibrationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalibrationCollectionViewCell")
        modulationCollectionView.register(UINib(nibName: "CalibrationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalibrationCollectionViewCell")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        boxLabel.numberOfLines = 0
        
        
        
        
        

        let size = bounds.size
        

        let labelMargin: CGFloat = 5
        channelLabel.pin.left(120).top(10)
        lnrCollectionView.pin.below(of: channelLabel, aligned: .center).marginTop(labelMargin).width(200).height(92)
        
        
        boxLabel.pin.width(20).height(size.height).left(of: lnrCollectionView).margin(10).vCenter()

        conductionCollectionView.pin.after(of: lnrCollectionView, aligned: .top).marginLeft(10).width(230).height(92)
        conductionLabel.pin.above(of: conductionCollectionView, aligned: .center).marginTop(10)

        typeCollectionView.pin.bottom(10).left(to: lnrCollectionView).width(225).height(92)
        typeLabel.pin.above(of: typeCollectionView, aligned: .center).marginBottom(labelMargin)

        pulseCollectionView.pin.after(of: typeCollectionView, aligned: .top).marginLeft(10).width(220).height(92)
        pulseLabel.pin.above(of: pulseCollectionView, aligned: .center).marginBottom(labelMargin)
        
        frequencyCollectionView.pin.topLeft(to: pulseCollectionView).width(180).height(92)
        frequencyLabel.pin.above(of: frequencyCollectionView, aligned: .center).marginBottom(labelMargin)
        
        modulationCollectionView.pin.after(of: frequencyCollectionView, aligned: .top).marginLeft(10).width(180).height(92)
        modulationLabel.pin.above(of: modulationCollectionView, aligned: .center).marginBottom(labelMargin)
    }

    func styleViews() {
        
        Styles.box.apply(to: self)
        Styles.label(font: fontStyle.size(24).weight(600).bold(), color: .blue)
            .align(.center)
            .vertical(value: false)
            .apply(text: "TONE", to: boxLabel.from(self))

        labelStyle.apply(text: "EAR", to: channelLabel.from(self))
        
        self.styleCollectionView(lnrCollectionView)
        self.styleCollectionView(conductionCollectionView)
        self.styleCollectionView(typeCollectionView)
        self.styleCollectionView(pulseCollectionView)
        self.styleCollectionView(frequencyCollectionView)
        self.styleCollectionView(modulationCollectionView)
        
        labelStyle.apply(text: "CONDUCTION", to: conductionLabel.from(self))
//        Styles.segmentedControl.apply(titles: "Air", "Bone", "Soundfield", to: conductionControl.from(self))

        labelStyle.apply(text: "TYPE", to: typeLabel.from(self))
//        Styles.segmentedControl.apply(titles: "Steady", "Warble", "Pulsed", to: typeControl.from(self))

        labelStyle.apply(text: "PULSE DURATION", to: pulseLabel.from(self))
//        Styles.segmentedControl.apply(titles: "200ms", "500ms", "1s", to: pulseControl.from(self))

        labelStyle.apply(text: "WARBLE FREQUENCY", to: frequencyLabel.from(self))
//        Styles.segmentedControl.apply(titles: "5Hz", "10Hz", "20Hz", to: frequencyControl.from(self))

        labelStyle.apply(text: "MODULATION", to: modulationLabel.from(self))
//        Styles.segmentedControl.apply(titles: "5%", "10%", "20%", to: modulationControl.from(self))
    }

    var labelStyle: LabelStyle {
        return Styles.label(font: fontStyle.size(15).bold(), color: .lightBlack)
    }

    var fontStyle: FontStyle {
        return Styles.font.normal
    }
    
    func earCollectionView(model:ConductionIdea){
        
        
        let conductionModel = model
         let channels = Observable.just(lnrItems)
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
                self.lrIndexpath.removeAll()
                self.lrIndexpath.append(item)
                conductionModel.conductionIndexPath.value.removeAll()
                conductionModel.conductionIndexPath.value.append(item)
                self.lnrCollectionView.reloadData()
             }
             
         }.disposed(by: disposeBag)
         conductionModel.type ||> disposeBag
        
        let items = Observable.just(conductionItems)
        items
            .bind(to: self.conductionCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.conductionIndexPath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        conductionCollectionView.rx.itemSelected.bind(to: model.conductionIndexPathTone).disposed(by: disposeBag)
         
        model.conductionIndexPathTone.asObservable().subscribe { (event) in
            if let item = event.element{
                self.conductionIndexPath = item
                self.conductionCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
    }
    
    func setupTypeCollectionView(model: TonePlayerIdea){
//        typeCollectionView.delegate = self
        let items = Observable.just(typeItems)
        items
            .bind(to: self.typeCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.typeIndexPath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        typeCollectionView.rx.itemSelected.bind(to: model.typeIndexPath).disposed(by: disposeBag)
         
        model.typeIndexPath.asObservable().subscribe { (event) in
            if let item = event.element{
                self.typeIndexPath = item
                self.typeCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    func setupPulseCollectionView(model: TonePlayerIdea){
//        pulseCollectionView.delegate = self
        let items = Observable.just(pulseItems)
        items
            .bind(to: self.pulseCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.pulseIndexPath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        pulseCollectionView.rx.itemSelected.bind(to: model.pulseDurationIndexPath).disposed(by: disposeBag)
         
        model.pulseDurationIndexPath.asObservable().subscribe { (event) in
            if let item = event.element{
                self.pulseIndexPath = item
                self.pulseCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    func setupFrequencyCollectionView(model: TonePlayerIdea){
//        frequencyCollectionView.delegate = self
        let items = Observable.just(frequencyItems)
        items
            .bind(to: self.frequencyCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.frequencyIndexPath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        frequencyCollectionView.rx.itemSelected.bind(to: model.warbleFrequencyIndexPath).disposed(by: disposeBag)
         
        model.warbleFrequencyIndexPath.asObservable().subscribe { (event) in
            if let item = event.element{
                self.frequencyIndexPath = item
                self.frequencyCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    func setupModulationCollectionView(model: TonePlayerIdea){
//        modulationCollectionView.delegate = self
        let items = Observable.just(modulationItems)
        items
            .bind(to: self.modulationCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                cell.selectedImage.image = indexPath == self.modulationIndexPath ? UIImage(named: "01") : UIImage(named: "02")
            return cell
        }.disposed(by: disposeBag)
        
        modulationCollectionView.rx.itemSelected.bind(to: model.warbleModulationIndexPath).disposed(by: disposeBag)
         
        model.warbleModulationIndexPath.asObservable().subscribe { (event) in
            if let item = event.element{
                self.modulationIndexPath = item
                self.modulationCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
}

extension ToneSettingsView {
    func bind(model: TonePlayerIdea) {
        model.settings ||> player.settings ||> disposeBag
        model.test.playDidTapped ||> player.play ||> disposeBag
        model.test.pauseDidTapped ||> player.stop ||> disposeBag
        setupTypeCollectionView(model: model)
        
        if let channel = AgoraRtm.rtmChannel{
            model.settings.subscribe({ (toneset) in
                self.sendRawMessage(toneset.element,channel:channel)
            }).disposed(by: disposeBag)
        }
        

        model.isWarble ||> frequencyLabel.rx.isShown ||> disposeBag
        model.isWarble ||> frequencyCollectionView.rx.isShown ||> disposeBag
        setupFrequencyCollectionView(model: model)

        model.isWarble ||> modulationLabel.rx.isShown ||> disposeBag
        model.isWarble ||> modulationCollectionView.rx.isShown ||> disposeBag
        setupModulationCollectionView(model: model)
        
        model.isPulse ||> pulseLabel.rx.isShown ||> disposeBag
        model.isPulse ||> pulseCollectionView.rx.isShown ||> disposeBag
        setupPulseCollectionView(model: model)
    }
    
    func sendRawMessage(_ tone:ToneSettings?, channel:AgoraRtmChannel){
        
        if let sendSetting = tone?.getToneSendSettings(), let data = sendSetting.getData(){
            let rawMessage = AgoraRtmRawMessage(rawData: data, description: "toneSetting")
            channel.send(rawMessage) { (errorCode) in
                
            }
        }
    }
}

extension ToneSettingsView {
    func bind(model: ConductionIdea) {
        earCollectionView(model: model)
//        channelControl.bind(model: model)
        // TODO
//        conductionControl.rx.value <||> model.conductionIndex ||> disposeBag
    }
}

extension ToneSettingsView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width:CGFloat = 60
        if collectionView == conductionCollectionView{
            width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 15), text: conductionItems[indexPath.row]) + 16
        }
        if collectionView == lnrCollectionView{
            width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 15), text: lnrItems[indexPath.row]) + 16
        }
        if width < 60 {
            width = 60
        }
        if collectionView == frequencyCollectionView || collectionView == modulationCollectionView{
            width = 50
        }
        return CGSize(width: width, height: 92)
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return ceil(labelSize.width)
    }
    
    func isTruncated() -> Bool {
        if let string = self.text {
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: self.font],
                context: nil).size
            return (size.height > self.bounds.size.height)
        }
        return false
    }
}
