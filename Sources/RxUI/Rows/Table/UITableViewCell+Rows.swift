//
//  UITableViewCell+Rows.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/5/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableViewCell {
    class var identifier: String {
        return basename.removeSuffix("Cell").lowerFirst
    }
}

extension Reactive where Base: UITableViewCell {
    var isSelected: ControlEvent<Bool> {
        let source = methodInvoked(#selector(UITableViewCell.setSelected(_:animated:))).map { $0.first as! Bool }
        return ControlEvent(events: source)
    }
}
