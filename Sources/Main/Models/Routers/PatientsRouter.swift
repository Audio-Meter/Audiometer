//
//  PatientsRouter.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/10/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct PatientsRouter {
    static func presentModalPatientsInfo(from: UIViewController) {
        let storyboard = UIStoryboard(name: "Patients", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "PatientsInfoNavigationController")
        from.present(navVC, animated: true, completion: nil)
    }
}
