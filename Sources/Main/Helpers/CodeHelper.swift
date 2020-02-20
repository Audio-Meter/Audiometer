//
//  CodeHelper.swift
//  Audiometer
//
//  Created by Bogachov on 26.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation
struct CodeHelper {
    static func codeToString(codes: [(MedicalCode, Bool)]?) -> String {
        guard let codes = codes else {
            return ""
        }
        var codesArray = [[String: Any]]()
        for code in codes {
            codesArray.append(["code": code.0.title,
                               "description": code.0.description ?? "",
                               "selected": code.1,
            ])
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: codesArray, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        guard let string = jsonString else { return ""}
        return string
    }
    
    static func cptToString(codes: [(MedicalCode, Bool)]?) -> String? {
        guard let codes = codes else { return nil }
        let codesArray = codes.map({ ["title": $0.0.title] })
        let jsonData = try? JSONSerialization.data(withJSONObject: codesArray, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString
    }
    
    static func stringToCode(string: String?, codes: [MedicalCode]) -> [(MedicalCode, Bool)] {
        guard let data = string?.data(using: .utf8) else {
            return []
        }
        let json = (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]]
        guard let safeJson = json else {
            return []
        }
        
        var codeArray: [(MedicalCode, Bool)] = []
        for codeJson in safeJson {
            if let icdCode = codes.first(where: { $0.title == (codeJson["code"] as! String) }) {
                codeArray.append((icdCode, codeJson["selected"] as! Bool))
            }
        }
        return codeArray
    }
}
