//
//  DatePickerCollectionViewCell.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/4/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

typealias DatePickerCollectionViewCellDidSelectDate = (Date) -> ()

class DatePickerCollectionViewCell: TextFieldCollectionViewCell {
    var didSelectDateHandler: DatePickerCollectionViewCellDidSelectDate?
    
    override class var reuseIdentifier: String {
        return "DatePickerCollectionViewCell"
    }
    
    @IBAction func showDatePicker() {
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .date, selectedDate: Date(), doneBlock: {[weak self] (picker, selectedDate, val2) in
            guard let date = selectedDate as? Date else {
                return
            }
            self?.didSelectDateHandler?(date)
        }, cancel: { (picker) in
            
        }, origin: self)
    }
}
