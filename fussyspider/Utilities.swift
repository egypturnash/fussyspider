//
//  Utilities.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/20/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit
import EventKit

//
// Helper functions
//
//

/// Request access to entityType in .eventStore, defaults to EKReminder
func requestEventAccess(entityType: EKEntityType = .Reminder, authorized: () -> Void = {}) {
  eventStore.requestAccessToEntityType(entityType, completion:
    {(granted, error) in
      // Proper error handling eventually
      if !granted {
        print("Access to Event Store not granted\n")
        print(error)
      } else {
        authorized()
      }
  })
}

/// Check EventKit authorization status for entityType and perform appropriate action
func checkAuthorizationStatus(entityType: EKEntityType = .Reminder, authorized: () -> Void = {}) {
  let status = EKEventStore.authorizationStatusForEntityType(entityType)
  
  switch (status) {
  case .NotDetermined:
    // first run
    requestEventAccess(authorized: authorized)
  case .Authorized:
    // app is authorized
    authorized()
  case .Restricted, .Denied:
    // TODO: info view to help user set correct permissions
    print("Permission Denied")
  }
}

func requestNotificationAuthorization() {
  let application = UIApplication.sharedApplication()
  let settings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
  application.registerUserNotificationSettings(settings)
  application.cancelAllLocalNotifications()
}
