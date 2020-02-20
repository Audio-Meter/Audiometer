//
//  UITableViewCell+RxUI.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/15/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableViewCell {
    var didUsed: Observable<Void> {
        return methodInvoked(#selector(UITableViewCell.prepareForReuse)).void()
    }
}
