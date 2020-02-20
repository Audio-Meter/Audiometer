//
//  BaseViewController.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift


class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()

    var navigator: Navigator {
        return Navigator(source: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBarButtonItem.appearance().setTitleTextAttributes( [NSAttributedStringKey.font: FontStyle.normal.apply()], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: FontStyle.normal.apply()]
    }
}
