//
//  PageViewModel
//  Audiometer
//
//  Created by Sergey Kachan on 2/6/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit

protocol PageViewModel {
    func createController(router: Router) -> UIViewController
}
