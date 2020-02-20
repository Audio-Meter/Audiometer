//
//  String+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

extension String {
    var lowerFirst: String {
        if self.count == 0 {
            return self
        } else {
            return String(self[self.startIndex]).lowercased() + String(self.dropFirst())
        }
    }

    func removeSuffix(_ suffix: String) -> String {
        if hasSuffix(suffix) {
            return String(self[..<index(endIndex, offsetBy: -suffix.count)])
        }
        return self
    }
}
