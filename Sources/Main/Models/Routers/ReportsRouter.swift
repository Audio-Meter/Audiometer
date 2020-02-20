//
//  ReportsRouter.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/16/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

struct ReportsRouter {
    static func show(report: Report, from: UIViewController) {
        let router = Router(storyboard: UIStoryboard.reportsStoryboard)
        let reportsPage = Report1Page(report: report)
        
        let vc = reportsPage.createController(router: router)
        from.navigationController?.pushViewController(vc, animated: true)        
    }
}
