//
//  AudiosRouter.swift
//  Audiometer
//
//  Created by Lewis Zhou on 11/6/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import UIKit

struct AudiosRouter {
    static func show(from: UIViewController) {
        let storyboard = UIStoryboard(name: "Audio", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "AudioNavigationController")
        from.present(navVC, animated: true, completion: nil)
    }
}
