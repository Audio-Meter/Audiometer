//
//  WordCell.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell, Bindable {
    func bind(model: Word) {
        textLabel?.text = model.text
    }
}
