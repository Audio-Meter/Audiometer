//
//  MenuItemCell.swift
//  Audiometer
//
//  Created by Eugene Fozekosh on 5/3/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    var shouldBeSelected = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHighlighted = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.isHighlighted = true
        } else {
            self.isHighlighted = false
        }
    }
    
    
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                if self.shouldBeSelected {
                    self.contentView.backgroundColor = ColorStyle.semiTransparentBlue.apply()
                }
                else {
                    self.contentView.backgroundColor = UIColor.clear
                }
                self.titleLabel.textColor = UIColor.white
            }
            else {
                if self.shouldBeSelected {
                    self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                    self.titleLabel.textColor = ColorStyle.blue.color
                }
                else {
                    self.contentView.backgroundColor = UIColor.clear
                    self.titleLabel.textColor = UIColor.white
                }
            }
            super.isHighlighted = newValue
        }
    }
}
