//
//  SegmentedCollectionViewCell.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class SegmentedCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    class var reuseIdentifier: String {
        return "SegmentedCollectionViewCell"
    }
}

