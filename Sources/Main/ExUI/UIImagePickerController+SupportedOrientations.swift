//
//  UIImagePickerController+SupportedOrientations.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 9/16/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation

extension UIImagePickerController
{
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }
}
