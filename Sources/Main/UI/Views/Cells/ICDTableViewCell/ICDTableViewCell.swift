//
//  ICDTableViewCell.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/8/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class ICDTableViewCell: BaseTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        yesButton.layer.cornerRadius = yesButton.bounds.height / 2
        noButton.layer.cornerRadius = noButton.bounds.height / 2
        nameLabel.font = FontStyle.normal.apply()
//        favoriteButton.layer.cornerRadius = favoriteButton.bounds.height / 2
    }
    
    func bind(code: MedicalCode, report: Report) {
        yesButton.rx.tap.subscribe(onNext: {
            if report.answerForCode(code: code) == true {
                report.setAnswerForCode(code: code, answer: nil)
                self.handleCodeAnswer(nil)
            } else {
                report.setAnswerForCode(code: code, answer: true)
                self.handleCodeAnswer(true)
            }
        }).disposed(by: disposeBag)
        
        noButton.rx.tap.subscribe(onNext: {
            if report.answerForCode(code: code) == false {
                report.setAnswerForCode(code: code, answer: nil)
                self.handleCodeAnswer(nil)
            } else {
                report.setAnswerForCode(code: code, answer: false)
                self.handleCodeAnswer(false)
            }
        }).disposed(by: disposeBag)
        
//        favoriteButton.rx.tap.subscribe(onNext: {
//            User.current?.favUnfav(code: code, completion: { (_) in
//            })
//        }).disposed(by: disposeBag)

        nameLabel?.text = code.fullName

        self.handleCodeAnswer(report.answerForCode(code: code))
//        User.current?.favCodes.asObservable().subscribe(onNext: { [weak self] (favCodes) in
//            guard let `self` = self else {
//                return
//            }
//            if favCodes.contains(code) {
//                self.handleSelectedState(selected: true, button: self.favoriteButton)
//            } else {
//                self.handleSelectedState(selected: false, button: self.favoriteButton)
//            }
//        }).disposed(by: disposeBag)
    }
    
    private func handleCodeAnswer(_ answer:Bool?) {
        if let answer = answer {
            if answer {
                handleSelectedState(selected: true, button: yesButton)
                handleSelectedState(selected: false, button: noButton)
            } else {
                handleSelectedState(selected: false, button: yesButton)
                handleSelectedState(selected: true, button: noButton)
            }
        } else {
            handleSelectedState(selected: false, button: yesButton)
            handleSelectedState(selected: false, button: noButton)
        }
    }
    
    private func handleSelectedState(selected: Bool, button: UIButton) {
        if selected {
            let buttonStyle = Styles.button.solid()
            buttonStyle.apply(to: button)
            button.setImage(#imageLiteral(resourceName: "SaveIcon"), for: .normal)
        } else {
            let buttonStyle = Styles.button.bordered()
            buttonStyle.apply(to: button)
            button.setImage(nil, for: .normal)
        }
    }
    
    class var reuseIdentifier: String {
        return "ICDTableViewCell"
    }
}
