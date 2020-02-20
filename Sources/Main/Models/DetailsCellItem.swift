//
//  DetailsCellItem.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import RxSwift

enum DetailsCellItemType {
    case textField
    case datePicker
    case segmentControl
}

protocol DetailItemCellProtocol {
    var description: String { get set }
    var valueDescription: String { get }
    var type: DetailsCellItemType { get set }
}

struct DetailsCellStringItem: DetailItemCellProtocol {
    
    enum Format {
        case none, wordCap, allCap, hyphen(String)
    }
    
    var valueDescription: String {
        return variable.value
    }
    
    var description: String
    var type: DetailsCellItemType
    let variable: Variable<String>
    let format: Format
    
    init(variable: Variable<String>, description: String, format: Format = .none, type: DetailsCellItemType = .textField) {
        self.variable = variable
        self.description = description
        self.type = type
        self.format = format
    }
}

struct DetailsCellSegmentedItem: DetailItemCellProtocol {
    var valueDescription: String {
        return String(selectedIndex.value.rawValue)
    }
    
    var description: String
    var type: DetailsCellItemType
    var segmentTitles: [String]
    let selectedIndex: Variable<Genders>
    
    init(selectedIndex: Variable<Genders>, description: String, type: DetailsCellItemType = .segmentControl, segmentTitles: [String]) {
        self.description = description
        self.type = type
        self.selectedIndex = selectedIndex
        self.segmentTitles = segmentTitles
    }
}

struct DetailsCellDateItem: DetailItemCellProtocol {
    var description: String
    var type: DetailsCellItemType
    let variable: Variable<Date?>
    
    var valueDescription: String {
        guard let date = variable.value else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter.string(from: date)
    }
    
    init(variable: Variable<Date?>, description: String) {
        self.description = description
        self.type = .datePicker
        self.variable = variable
    }
}
