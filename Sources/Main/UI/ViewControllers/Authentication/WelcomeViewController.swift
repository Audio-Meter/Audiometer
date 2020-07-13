//
//  WelcomeViewController.swift
//  Audiometer
//
//  Created by Eugene Fozekosh on 4/27/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation


class WelcomeViewController: BaseViewController {
    
    class var viewController: WelcomeViewController{
        return UIStoryboard.authenticationStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as!  WelcomeViewController
    }
    
}
