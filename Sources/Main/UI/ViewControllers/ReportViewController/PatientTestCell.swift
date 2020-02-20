//
//  PatientTestCell.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PatientTestCell: BaseTableViewCell {
    @IBOutlet var date: UILabel!
    @IBOutlet var mark: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension PatientTestCell: Bindable {
    func bind(model: PatientTest) {
        date.text = model.date.format()
        rx.isSelected ||> mark.rx.isHidden ||> disposeBag
    }
}
