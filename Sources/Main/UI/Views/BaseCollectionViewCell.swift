//
//  BaseCollectionViewCell.swift
//  Audiometer
//
//  Created by Alex Bibikov on 4/17/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
