//
//  ReportCodeCell.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/13/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReportCodeCell: BaseTableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var value: UISwitch!
}

extension ReportCodeCell: Bindable {
    func bind(model: ReportCodeCellModelProtocol) {
        name.text = model.name
        value.rx.value <||> model.value ||> disposeBag
        rx.didUsed ||> model.used ||> disposeBag
    }
}
