//
//  SettingsRouter.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/26/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct SettingsRouter {
    static func presentModalSettings(from: UIViewController, container: PersistentContainer) {
        let storyboard = UIStoryboard(name: "ClinicAndClinicianSelect", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return;
        }
        
        for c in vc.viewControllers {
            if let innerController = c as? ClinicClinicianViewController {
                innerController.container = container
                // obj is a String. Do something with str
            }
            else {
            }
        }

        from.present(vc, animated: true, completion: nil)
    }
}
