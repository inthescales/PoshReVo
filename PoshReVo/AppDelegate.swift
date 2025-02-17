//
//  AppDelegate.swift
//  PoshReVo
//
//  Created by Robin Hill on 12/28/15.
//  Copyright © 2015 Robin Hill. All rights reserved.
//

import CoreData

import UIKit
import iOS_Slide_Menu

import ReVoDatumbazo

let datumbazNomo = "PoshReVoDatumbazo"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var fenestro: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        VortaroDatumbazo.komuna = VortaroDatumbazo(konteksto: managedObjectContext)
        
        UzantDatumaro.starigi()
        
        let navilo = ChefaNavigationController()
        
        fenestro = UIWindow(frame: UIScreen.main.bounds)
        fenestro?.rootViewController = navilo
        fenestro?.makeKeyAndVisible()
        
        Stiloj.efektivigiStilon(UzantDatumaro.stilo)
        
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let datumbazBundle = Bundle(identifier: "inthescales.ReVoDatumbazo")!
        let modelURL = datumbazBundle.url(forResource: "PoshReVoDatumoj", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let docsUrl = self.applicationDocumentsDirectory.appendingPathComponent(datumbazNomo + ".sqlite")
        let bundleUrl = Bundle.main.url(forResource: datumbazNomo, withExtension: "sqlite")

        do {
            let pragmas: [String : String] = ["journal_mode" : "DELETE", "synchronous" : "OFF"]
            let options = [NSReadOnlyPersistentStoreOption : true, NSSQLitePragmasOption : ["journal_mode" : "DELETE", "synchronous" : "OFF"]] as [String : Any]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: bundleUrl, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Malsukcesis sharghante je datumoj"
            dict[NSLocalizedFailureReasonErrorKey] = "Eraro sharghante je datumoj"
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
		managedObjectContext.undoManager = nil
        return managedObjectContext
    }()
}

