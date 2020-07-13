//
//  LanguageCollectionViewCell.swift
//  Audiometer
//
//  Created by Arun Jangid on 27/05/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit

class LanguageCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var langTitle: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    func configure(_ lang:LanguageSelect){
        if isSelected{
            contentView.backgroundColor = UIColor(red: 88.0/255.0, green: 195.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        }else{
            contentView.backgroundColor = .white
        }
        icon.image = lang.data.icon
        langTitle.text = lang.data.text
    }
}
