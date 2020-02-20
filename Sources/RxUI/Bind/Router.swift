//
//  Router.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

class Router {
    let storyboard: UIStoryboard

    init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }

    func createController(page: PageViewModel) -> UIViewController {
        return page.createController(router: self)
    }
    
    func createController<Page,Controller:UIViewController>(page: Page) -> Controller where Controller:Bindable,Controller.Model == Page {
        let controller:Controller = createController()
        _ = controller.view
        controller.bind(model: page)
        return controller
    }

    func createController2<Page,Controller:FreeViewController>(page: Page) -> Controller where Controller:Bindable,Controller.Model == Page {
        let controller:Controller = Controller()
        _ = controller.view
        controller.bind(model: page)
        return controller
    }

    func createController<Controller:UIViewController>() -> Controller {
        return createController(identifier: Controller.identifier)
    }

    func createController<Controller>(identifier: String) -> Controller {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Controller
    }
}
