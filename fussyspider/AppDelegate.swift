//
//  AppDelegate.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit
import EventKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var fussyReminders: [FussyReminder] = []
    var fussyTags: [FussyTag] = []
   
    let eventStore = EKEventStore()
    let locationManager = CLLocationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        requestEventAccess()
        loadAllFussyTags()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveAllFussyTags()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveAllFussyTags()
    }
    
    //
    // MARK: CLLocationManager
    //
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func handleRegionEvent(region: CLRegion) {
        print("Geofence triggered!")
    }
    
    //
    // MARK: EventKit
    //
    /// Request access to entityType in .eventStore, defaults to EKReminder
    func requestEventAccess(entityType: EKEntityType = EKEntityType.Reminder) {
        eventStore.requestAccessToEntityType(entityType, completion:
            {(granted, error) in
                // Proper error handling eventually
                if !granted {
                    print("Access to Event Store not granted\n")
                    print(error)
                }
        })
    }
    
    //
    // MARK: NSUserDefaults
    //
    /// Loads AppDelegate.fussyTags with from NSUserDefaults
    func loadAllFussyTags() {
        fussyTags = []
        if let tags = NSUserDefaults.standardUserDefaults().arrayForKey("fussyTags") {
            for tag in tags {
                if let fussyTag = NSKeyedUnarchiver.unarchiveObjectWithData(tag as! NSData) as? FussyTag {
                    fussyTags.append(fussyTag)
                }
            }
        }
    }
    
    /// Saves AppDelegatefussyTags to NSUserDefaults
    func saveAllFussyTags() {
        let tags = NSMutableArray()
        for fussyTag in fussyTags {
            let tag = NSKeyedArchiver.archivedDataWithRootObject(fussyTag)
            tags.addObject(tag)
        }
        NSUserDefaults.standardUserDefaults().setObject(tags, forKey: "fussyTags")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

