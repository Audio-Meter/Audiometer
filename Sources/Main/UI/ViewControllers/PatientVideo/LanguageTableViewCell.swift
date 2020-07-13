//
//  LanguageTableViewCell.swift
//  Audiometer
//
//  Created by Arun Jangid on 29/04/20.
//  Copyright © 2020 Melmedtronics. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var langTitle: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ lang:LanguageSelect){
        if isSelected{
            contentView.backgroundColor = UIColor(red: 88.0/255.0, green: 195.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        }else{
            contentView.backgroundColor = .clear
        }
        icon.image = lang.data.icon
        langTitle.text = lang.data.text
    }

}
