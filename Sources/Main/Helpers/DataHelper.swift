//
//  DataHelper.swift
//  Audiometer
//
//  Created by Bogachov on 22.06.2018.
//  Copyright © 2018 Melmedtronics. All rights reserved.
//

import Foundation
struct DataHelper {
    static func stringToDate(dataString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dataString)!
    }
}
