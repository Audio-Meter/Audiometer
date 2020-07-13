//
//  PatientsRouter.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/10/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import AgoraRtcKit
import AgoraRtmKit

struct PatientsRouter {
    static func presentModalPatientsInfo(from: UIViewController,rtmChannel: AgoraRtmChannel?) {
        let storyboard = UIStoryboard(name: "Patients", bundle: nil)
        let navVC:UINavigationController = storyboard.instantiateViewController(withIdentifier: "PatientsInfoNavigationController") as! UINavigationController
        if let rtmchannel = rtmChannel, let patientVC = navVC.topViewController as? PatientsViewController{
            patientVC.rtmChannel = rtmchannel
        }
        from.present(navVC, animated: true, completion: nil)
    }
}
