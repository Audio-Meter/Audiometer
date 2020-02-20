//
//  UITextField+Extension.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 7/16/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import UIKit

extension UIView {
    func setLeftBorder() {
        self.layer.masksToBounds = false;
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: -1.0, height: 0)
        
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 0;
    }
    
    func setRightBorder() {
        self.layer.masksToBounds = false;
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 0)
        
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 0;
    }
    
    
    func setBottomBorder() {
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
