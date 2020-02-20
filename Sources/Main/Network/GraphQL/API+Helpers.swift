//
//  API+Helpers.swift
//  Audiometer
//
//  Created by Roman Stetsenko on 6/23/18.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation
import UIKit

private let jpegMimePrefix = "data:image/jpeg;base64,"

extension String {
    static func base64StringForApi(image: UIImage) -> String? {
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
            return nil
        }
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        return jpegMimePrefix + base64String
    }
    
    func base64ImageFromApi() -> UIImage? {
        var string = self
        if string.hasPrefix(jpegMimePrefix) {
            string = String(string.dropFirst(jpegMimePrefix.count))
        }
        if let imageData = Data(base64Encoded: string) {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
    //TODO: make one func for all types
    static func base64StringForJPGApi(path: String) -> String? {
        guard let fileData = NSData(contentsOfFile: path) else {
            return nil
        }
        let base64String = fileData.base64EncodedString(options: .lineLength64Characters)
        return "data:image/jpeg;base64," + base64String
    }
    
    static func base64StringForPNGApi(path: String) -> String? {
        guard let fileData = NSData(contentsOfFile: path) else {
            return nil
        }
        let base64String = fileData.base64EncodedString(options: .lineLength64Characters)
        return "data:image/png;base64," + base64String
    }
    
    static func base64StringForPDFApi(path: String) -> String? {
        guard let fileData = NSData(contentsOfFile: path) else {
            return nil
        }
        let base64String = fileData.base64EncodedString(options: .lineLength64Characters)
        return "data:application/pdf;base64," + base64String
    }
    

}

extension Tests {
    static let allTypes = [tone, speech]
    
    var title: String {
        switch self {
        case .tone:
            return "AC/BC"
        case .speech:
            return "SRT/SD"
        case .__unknown(_):
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .tone:
            return "Tone Tests"
        case .speech:
            return "Speech Tests"
        case .__unknown(_):
            return ""
        }
    }
}
