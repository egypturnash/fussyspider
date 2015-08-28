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
    var tagFilter: [String] = []
   
    let eventStore = EKEventStore()
    let locationManager = CLLocationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        requestEventAccess()
        loadAllFussyTags()
        let settings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
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
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with name: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func handleRegionEvent(region: CLRegion) {
        // Update this to only notify for tags w/ reminders
        print("Geofence triggered!")
        let notification = UILocalNotification()
        notification.alertBody = region.identifier
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func registerFenceForTag(tag: FussyTag) {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            print("This device lacks support for geofencing.")
        }
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            print("The geofence will save but you need to grant permission for the app to access the device location.")
        }
        
        let region = CLCircularRegion(center: tag.location.coordinate, radius: CLLocationDistance(tag.radius!), identifier: tag.name!)
        region.notifyOnEntry = (tag.type == .Entry)
        region.notifyOnExit = (tag.type == .Exit)
        
        locationManager.startMonitoringForRegion(region)
        print("Registered region for \(tag.name)")
    }
    
    //
    // MARK: EventKit
    //
    /// Request access to entityType in .eventStore, defaults to EKReminder
    func requestEventAccess(entityType: EKEntityType = .Reminder) {
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
                    registerFenceForTag(fussyTag)
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

