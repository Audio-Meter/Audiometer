//
//  LocalClinic.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/26/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import CoreData

class LocalClinic : GenericModel {
    var server_id: String?
    var name: String?
    var email: String?
    var address: String?
    var tel: String?
    var fax: String?
    var website: String?
    var objectID: NSManagedObjectID?
    var sync: Bool = false
    var signature: NSData?
    var logo: NSData?
}
