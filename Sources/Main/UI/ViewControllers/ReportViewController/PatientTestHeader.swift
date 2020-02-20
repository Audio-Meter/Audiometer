//
//  PatientTestHeader.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/19/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class PatientTestHeader: UITableViewHeaderFooterView {
    @IBOutlet var name: UILabel!
}

extension PatientTestHeader: Bindable {
    func bind(model: PatientTestHeaderModel) {
        name.text = model.name
    }
}
