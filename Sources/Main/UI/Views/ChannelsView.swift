//
//  ChannelsView.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/27/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa

class ChannelsView: UIView {
    let disposeBag = DisposeBag()

    let left = UIButton()
    let right = UIButton()
    
    let leftlbl = UILabel()
    let rightlbl = UILabel()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        styleViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleViews()
    }

    func styleViews() {
        let buttonStyle = Styles.button.bordered()
        
        buttonStyle.apply(title: "",buttonImage:UIImage(named: "01.png")!, to: left.from(self))
        buttonStyle.apply(title: "",buttonImage:UIImage(named: "02.png")!, to: right.from(self))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        left.pin.left().vertically().right(50%).marginRight(5)
       
        right.pin.right().vertically().left(50%).marginLeft(5)
    }
}

extension ChannelsView: Bindable {
    func bind(model: ConductionIdea) {
        left.rx.tap ||> { .left } ||> model.channel ||> disposeBag
        right.rx.tap ||> { .right } ||> model.channel ||> disposeBag
        model.left ||> Styles.button.selected ||> left ||> disposeBag
        model.right ||> Styles.button.selected ||> right ||> disposeBag
    }
}
