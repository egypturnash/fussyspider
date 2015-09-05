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

let eventStore = EKEventStore()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
  
  var window: UIWindow?
  let locationManager = CLLocationManager()
  let tagStore = FSTagStore()
  let taskStore = FSTaskStore()
  let application = UIApplication.sharedApplication()
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    requestNotificationAuthorization()
    taskStore.loadAllTasks()
    registerGeofences()
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  // MARK: Location Manager
  func registerGeofences () {
    for tag in tagStore.getAllTags() {
      if taskStore.taskWithTagExists(tag) {
        registerFenceForTag(tag)
      }
    }
  }
  
  func handleRegionEvent(region: CLRegion) {
    let notification = UILocalNotification()
    var body : String = ""
    for task in taskStore.getAllTasks() {
      for tag in task.tags {
        if tag.title! == region.identifier {
          body += "\(task.task.title)\n"
        }
      }
    }
    notification.alertBody = body
    notification.soundName = "Default";
    application.presentLocalNotificationNow(notification)
  }
  
  func registerFenceForTag(tag: FSTag) {
    if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
      print("This device lacks support for geofencing.")
    }
    if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
      print("The geofence will save but you need to grant permission for the app to access the device location.")
    }
    
    let region = CLCircularRegion(center: tag.coordinate, radius: tag.radius, identifier: tag.title!)
    region.notifyOnEntry = ([.Entry, .Both].contains(tag.type))
    region.notifyOnExit = ([.Exit, .Both].contains(tag.type))
    
    locationManager.startMonitoringForRegion(region)
    print("Registered region for \(tag.title!)")
  }
  
  // MARK: CLLocationManagerDelegate protocol functions
  
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
}

