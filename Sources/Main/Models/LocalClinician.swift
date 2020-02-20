//
//  LocalClinician.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/30/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import CoreData

class LocalClinician : GenericModel {
    var server_id: String?
    var objectID: NSManagedObjectID?
    var name: String?
    var email: String?
    var certification: String?
    var degrees: String?
    var pcp: Bool?
    var sync: Bool = false
    var signature: NSData?
}
