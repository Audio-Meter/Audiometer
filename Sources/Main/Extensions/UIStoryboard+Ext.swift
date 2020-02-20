//
//  UIStoryboard+Ext.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/11/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class var patientsStoryboard: UIStoryboard {
        return UIStoryboard(name: "Patients", bundle: nil)
    }
    
    class var codesStoryboard: UIStoryboard {
        return UIStoryboard(name: "Codes", bundle: nil)
    }
    
    class var authenticationStoryboard: UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: nil)
    }
    
    class var testsStoryboard: UIStoryboard {
        return UIStoryboard(name: "Tests", bundle: nil)
    }
    
    class var reportsStoryboard: UIStoryboard {
        return UIStoryboard(name: "Reports", bundle: nil)
    }
}
