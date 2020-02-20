//
//  AppDelegate.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Apollo
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var isFromCalibration = false
    
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "OfflineData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        UINavigationBar.appearance().backgroundColor = Styles.color.red.color
        UINavigationBar.appearance().barTintColor = Styles.color.red.color

//        if let rootVC = window?.rootViewController as? ViewController {
//        }

        let storage = Storage(storage: self.persistentContainer)
        guard let userEmail = Storage.currentUser() else {
            return true
        }

        if (!userEmail.isEmpty && storage.getUserByEmail(userEmail) != nil) {
            let rootVC = MenuViewController.viewController
            self.window?.rootViewController = rootVC
        }
//        if ApolloClient.isAuthorized {
//            let rootVC = MenuViewController.viewController
////            rootVC.container = persistentContainer
//
//            self.window?.rootViewController = rootVC
//        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

