//
//  AppDelegate.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/18/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print the location of realm file
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Error printing fileURL path")
        
        do{
            _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }
}

