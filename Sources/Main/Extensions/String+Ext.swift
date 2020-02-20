//
//  String+Ext.swift
//  Audiometer
//
//  Created by Roman Stetsenko on 8/3/18.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation

extension String {
    func formattedNumber(mask: String) -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = mask.uppercased()
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    var withoutSpecialCharacters: String {
        
        let allowedCharacters = CharacterSet.whitespaces.union(CharacterSet.decimalDigits).union(CharacterSet.letters)
        let filteredName = self.filter { (c) -> Bool in
            return !c.unicodeScalars.contains(where: { !allowedCharacters.contains($0)})
        }

//        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
        return filteredName
    }
}
