//
//  BaseTableViewCell.swift
//  Audiometer
//
//  Created by Sergey Kachan on 3/15/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
