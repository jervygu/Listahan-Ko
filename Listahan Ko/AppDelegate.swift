//
//  AppDelegate.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/18/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print the location of realm file
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Error printing fileURL path")
        
        
        
        do{
            let realm = try Realm()
            
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        
        self.saveContext()
    }
    
    

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

