//
//  TextFieldCollectionViewCell.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet var textField: UITextField!
    @IBOutlet var separatorView: UIView!

    class var reuseIdentifier: String {
        return "TextFieldCollectionViewCell"
    }
}

