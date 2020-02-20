//
//  PersistentContainer.swift
//  Audiometer
//
//  Created by Zhenya Zhou on 8/30/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
