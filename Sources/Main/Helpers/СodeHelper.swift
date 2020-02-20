//
//  СodeHelper.swift
//  Audiometer
//
//  Created by Bogachov on 25.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation
struct CodeHelper {
    static func codeToString(codes: [MedicalCode]) -> String {
        var codeArray: [String] = []
        for code in codes{
            codeArray.append(code.title)
        }
        return codeArray.joined(separator: ", ")
    }

}
