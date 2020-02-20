//
//  Navigator.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import SafariServices

class Navigator {
    weak var source: UIViewController?

    init(source: UIViewController) {
        self.source = source
    }

    func push<Page:PageViewModel>(_ page: Page) {
        show(page: page, present: push)
    }

    func push(_ controller: UIViewController) {
        source?.navigationController?.pushViewController(controller, animated: true)
    }

    func back() {
        source?.navigationController?.popViewController(animated: true)
    }

    func present<Page:PageViewModel>(_ page: Page) {
        show(page: page, present: present)
    }

    func present(_ controller: UIViewController) {
        source?.present(controller, animated: true)
    }

    func dismiss() {
        source?.dismiss(animated: false, completion: nil)
    }

    var router: Router? {
        guard let storyboard = source?.storyboard else {
            return nil
        }
        return Router(storyboard: storyboard)
    }
    
    private func show<Page:PageViewModel>(page: Page, present: (UIViewController)->Void) {
        guard let router = self.router else {
            return
        }
        present(page.createController(router: router))
    }
}
