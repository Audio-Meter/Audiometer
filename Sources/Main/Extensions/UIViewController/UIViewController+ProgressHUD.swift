//
//  UIViewController+ProgressHUD.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showProgressHUD()  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.font = FontStyle.normal.apply()
        hud.label.text = "Please Wait..."
        hud.removeFromSuperViewOnHide = true
        hud.minShowTime = 0.2
        
        hud.isSquare = true
        hud.bezelView.backgroundColor = .init(red: 133/255, green: 186/255, blue: 85/255, alpha: 1)
        hud.backgroundView.blurEffectStyle = .dark
        hud.contentColor = .white
        
        hud.label.textColor = .white
        hud.bezelView.color = ColorStyle.semiTransparentBlue.apply()
    }
    
    func hideProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
