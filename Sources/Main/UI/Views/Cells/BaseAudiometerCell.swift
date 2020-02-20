//
//  BaseAudiometerCell.swift
//  Audiometer
//
//  Created by Alex Bibikov on 6/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

typealias BaseAudiometerCellManualTap = () -> ()

class BaseAudiometerCell: UITableViewCell {
    var manualTapHandler: BaseAudiometerCellManualTap?
    
//    private lazy var leftLine: UIView = {
//        let leftLine = UIView(frame: .zero)
//        leftLine.translatesAutoresizingMaskIntoConstraints = false
//        leftLine.backgroundColor = Styles.color.red.color
//        self.addSubview(leftLine)
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line(==2)]",
//                                                                   options: [],
//                                                                   metrics: nil,
//                                                                   views: ["line" : leftLine]))
//
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]-1-|",
//                                                                   options: [],
//                                                                   metrics: nil,
//                                                                   views: ["line" : leftLine]))
//        leftLine.isHidden = true
//        return leftLine
//    }()

    private lazy var manualTapButton: UIButton = {
        let res = UIButton(type: .custom)
        res.isHidden = true
        res.addTarget(self, action: #selector(handleManualTap), for: .touchUpInside)
        self.addSubview(res)
        return res
    }()

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        leftLine.isHidden = !selected
//        self.bringSubview(toFront: leftLine)
//    }
    
    var needManualHandleTap = false {
        didSet {
            self.manualTapButton.isHidden = !needManualHandleTap
        }
    }
    
    @objc private func handleManualTap() {
        manualTapHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.font = FontStyle.normal.apply()
        manualTapButton.frame = self.bounds
    }
}
