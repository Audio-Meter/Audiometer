//
//  ToneMaskingView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/26/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AgoraRtcKit
import AgoraRtmKit

class ToneMaskingView: UIView {
    let disposeBag = DisposeBag()
    let player = MaskingPlayer()

    private let flowLayout = UICollectionViewFlowLayout()
    let boxLabel = UILabel()

    let onOffLabel = UILabel()
    let onOffControl = UISwitch()

    let amplitudeLabel = UILabel()
    let amplitudeMinus = UIButton(type: .custom)
    let amplitudePlus = UIButton(type: .custom)
    let amplitudeValue = UILabel()
    let amplitudeDb = UILabel()

    let amplitudeMinusLabel = UILabel()
    let amplitudePlusLabel = UILabel()
    
    let continuousLabel = UILabel()
    let continuousControl = UISwitch()

    let typeLabel = UILabel()
    let typeControl = UISegmentedControl()
    let typeItems = ["WN", "NBN"]
    let typeCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var typeIndexPath:IndexPath?

    let amplitudeView = UIView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleViews()
    }
    
    func styleCollectionView(_ collectionView:UICollectionView){
    //        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView.backgroundColor = .clear
            collectionView.clipsToBounds = true
            collectionView.cornerRadius = 8
            collectionView.borderWidth = 2
            collectionView.borderColor = UIColor(red: 75.0/255.0, green: 134.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
        }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.insertSubview(amplitudeView, at: 0)
        addSubview(typeCollectionView)
        typeCollectionView.register(UINib(nibName: "CalibrationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalibrationCollectionViewCell")
        let size = bounds.size
        
        
        

        let labelMargin: CGFloat = 5
        

        typeCollectionView.pin.right(20).bottom(10).width(160).height(92)
        typeLabel.pin.above(of: typeCollectionView, aligned: .center).marginBottom(10)
        
        continuousControl.pin.left(of: typeCollectionView, aligned: .center).margin(30)
        continuousLabel.pin.below(of: continuousControl, aligned: .center).marginTop(labelMargin)

//        typeControl.pin.right(20).bottom(to: continuousControl).width(125)
//        typeLabel.pin.left(to: typeControl).top(to: continuousLabel)
        
        amplitudeView.backgroundColor = .clear
        amplitudeView.clipsToBounds = true
        amplitudeView.cornerRadius = 8
        amplitudeView.borderWidth = 2
        amplitudeView.borderColor = UIColor(red: 75.0/255.0, green: 134.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        
        amplitudeView.backgroundColor = .clear
        amplitudeView.pin.height(92).width(160).right(20).top(30)
        amplitudeLabel.pin.above(of: amplitudeView, aligned: .center).marginBottom(10)
        
        onOffControl.pin.left(of: amplitudeView, aligned: .center).margin(30)
        onOffLabel.pin.below(of: onOffControl, aligned: .center).marginTop(labelMargin)
        
        boxLabel.pin.width(20).height(size.height).left(of: onOffControl).margin(30).vCenter()
//        amplitudeView.addSubview(amplitudePlus)
//        amplitudeView.addSubview(amplitudeMinus)
        
        amplitudeMinus.pin.height(50).width(50).right(of: onOffControl).top(5).margin(40)
        amplitudeValue.pin.below(of: amplitudeLabel, aligned: .center).margin(40)
        amplitudeDb.pin.below(of: amplitudeValue, aligned: .center).margin(labelMargin)
        amplitudePlus.pin.height(50).width(50).right(of: amplitudeMinus, aligned: .center).margin(40)
        
        amplitudeMinusLabel.pin.below(of: amplitudeMinus, aligned: .center).margin(0)
        amplitudePlusLabel.pin.below(of: amplitudePlus, aligned: .center).margin(0)
    }
    
    
    
    func setupTypeCollectionView(model: MaskingIdea){
        typeCollectionView.delegate = self
        let items = Observable.just(typeItems)
        items
            .bind(to: self.typeCollectionView.rx.items) { (collectionView, row, element) in
           let indexPath = IndexPath(row: row, section: 0)
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalibrationCollectionViewCell", for: indexPath) as! CalibrationCollectionViewCell
                cell.subTitle.text = element
                if self.typeIndexPath != nil{
                    cell.selectedImage.image = indexPath == self.typeIndexPath ? UIImage(named: "01") : UIImage(named: "02")
                }else{
                    cell.selectedImage.image = UIImage(named: "02")
                }
                
            return cell
        }.disposed(by: disposeBag)
        
        typeCollectionView.rx.itemSelected.bind(to: model.typeIndexPath).disposed(by: disposeBag)
        model.typeVariable ||> disposeBag
        
        model.typeIndexPath.asObservable().subscribe { (event) in
            if let item = event.element{
                self.typeIndexPath = item
                self.typeCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    

    func styleViews() {
        boxLabel.numberOfLines = 0
        Styles.box.apply(to: self)
        Styles.label(font: fontStyle.size(24).weight(600).bold(), color: .blue)
            .align(.center)
            .vertical(value: false)
            .apply(text: "MASKING", to: boxLabel.from(self))

        labelStyle.apply(text: "ON/OFF", to: onOffLabel.from(self))
        addSubview(onOffControl)

        labelStyle.apply(text: "CONTINUOUS", to: continuousLabel.from(self))
        addSubview(continuousControl)

        Styles.label(font: fontStyle.size(20).weight(600).bold(), color: .lightBlack)
        .align(.center)
        .vertical(value: false)
        .apply(text: "-", to: amplitudeMinusLabel.from(self))
        
        Styles.label(font: fontStyle.size(20).weight(600).bold(), color: .lightBlack)
        .align(.center)
        .vertical(value: false)
        .apply(text: "+", to: amplitudePlusLabel.from(self))
        
        
        
        styleAmplitude()
        
        styleCollectionView(typeCollectionView)

        labelStyle.apply(text: "TYPE", to: typeLabel.from(self))
//        Styles.segmentedControl.apply(titles: "WN", "NBN", to: typeControl.from(self))
    }

    func styleAmplitude() {
        let buttonStyle = Styles.button.Cleared().textFont(fontStyle.size(18))
        labelStyle.apply(text: "AMPLITUDE", to: amplitudeLabel.from(self))
            
        buttonStyle.apply(title: "",buttonImage:UIImage(named: "02")!, to: amplitudeMinus.from(self))
        
        buttonStyle.apply(title: "",buttonImage:UIImage(named: "02")!, to: amplitudePlus.from(self))

        labelStyle.font(fontStyle.size(17)).align(.center).apply(text: "40", to: amplitudeValue.from(self))
        Styles.label(font: fontStyle.size(14), color: .darkGray).align(.center).apply(text: "dB HL", to: amplitudeDb.from(self))
    }

    var labelStyle: LabelStyle {
        return Styles.label(font: fontStyle.size(15).bold(), color: .lightBlack)
    }

    var fontStyle: FontStyle {
        return Styles.font.normal
    }
}

extension ToneMaskingView {
    func bind(model: MaskingIdea) {
        onOffControl.rx.value <||> model.isEnabled ||> disposeBag
        continuousControl.rx.value ||> model.isContinuos ||> disposeBag

        model.amplitudeText ||> amplitudeValue.rx.text ||> disposeBag
        amplitudeMinus.rx.tap ||> model.minus ||> model.updateAmplitude ||> disposeBag
        amplitudePlus.rx.tap ||> model.plus ||> model.updateAmplitude ||> disposeBag
        
        
        if let rtmChannel = AgoraRtm.rtmChannel{
            model.config.subscribe({ (maskConfig) in
                self.sendRawMessage(maskConfig.element, channel: rtmChannel)
            }).disposed(by: disposeBag)                                    
        }else{
            model.config ||> player.rx.config ||> disposeBag
        }
        
        
        setupTypeCollectionView(model: model)
//        typeControl.rx.value <||> model.type ||> disposeBag
    }
    
    func sendRawMessage(_ masking:MaskingConfig?, channel:AgoraRtmChannel){
        if let sendSetting = masking?.getMaskingSetting(), let data = sendSetting.getData(){
            let rawMessage = AgoraRtmRawMessage(rawData: data, description: "maskSetting")
            channel.send(rawMessage) { (errorCode) in
                
            }
        }
    }
    
    
    
}
extension ToneMaskingView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width:CGFloat = 75
        width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 15), text: typeItems[indexPath.row]) + 16
        if width < 74 {
            width = 75
        }
        return CGSize(width: width, height: 92)
    }
}
