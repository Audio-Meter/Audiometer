//
//  LocalAudio.swift
//  Audiometer
//
//  Created by Lewis Zhou on 12/9/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import CoreData

class LocalAudio : GenericModel {
    var objectID: NSManagedObjectID?
    var name: String!
    var fileName: String!
    var txtFileName: String!
    var cacheFilePath: URL?
    var category: String!
//    var data: NSData?
    var beginTimePs = [Double]()
    var endTimePs = [Double]()
    var wordList = [String]()

}
