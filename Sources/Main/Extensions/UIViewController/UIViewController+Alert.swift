//
//  UIViewController+Alert.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

protocol AlertProtocol {
    func showAlert(title: String, message: String, buttonTitle: String)
    func showAlert(title: String, message: String, actions: [UIAlertAction], preferredStyle: UIAlertController.Style)
    func showAlert(title: String, message: String, actions: [UIAlertAction], preferredAction: UIAlertAction?,  preferredStyle: UIAlertController.Style)
    func showTryAgainErrorAlert(title: String, message: String, tryAgain: @escaping () -> ())
}

extension UIViewController: AlertProtocol {
    func showAlert(title: String, message: String, actions: [UIAlertAction], preferredStyle: UIAlertController.Style) {
        showAlert(title: title, message: message, actions: actions, preferredAction: nil, preferredStyle: preferredStyle)
    }
    
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated:true, completion: nil)
    }
    
    func showAlert(error: Error, title: String = "Error") {
        showAlert(title: title, message: error.localizedDescription, buttonTitle: "OK")
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction], preferredAction: UIAlertAction?,  preferredStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated:true, completion: nil)
        alert.preferredAction = preferredAction
    }
    
    func showTryAgainErrorAlert(title: String, message: String, tryAgain: @escaping () -> ()) {
        let tryAgainAction = UIAlertAction(title: "Try Again",
                                           style: .default) { (action) in
                                            tryAgain()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(tryAgainAction)
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
    }
}
