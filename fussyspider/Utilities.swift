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

// Takes a string and returns a string array of any hashtags (eg. #example)
func extractTags(input: String) -> [String] {
    
    var result : [String] = []
    let slices = input.componentsSeparatedByString(" ")
    for var slice in slices {
        if slice != "" {
            if slice.substringToIndex(advance(slice.startIndex, 1)) == "#" {
                slice.removeAtIndex(slice.startIndex)
                result.append(slice)
            }
        }        
    }
    return result
}

//
// MARK: EventKit
//
/// Request access to entityType in .eventStore, defaults to EKReminder
func requestEventAccess(entityType: EKEntityType = .Reminder, authorized: () -> Void = {}) {
    let eventStore = EKEventStore()
    
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

/// Get EKReminders from the EventStore, extract their tags and populate .reminders[]
func fetchReminders(tagFilter : [String], completion: () -> Void = {}) {
    
    if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        let eventStore = EKEventStore()
        delegate.fussyReminders = []
        
        let calendars = eventStore.calendarsForEntityType(.Reminder)
        let predicate = eventStore.predicateForRemindersInCalendars(calendars)
        
        eventStore.fetchRemindersMatchingPredicate(predicate, completion:
            { (reminders) in
                for reminder in reminders! {
                    let fussyReminder = FussyReminder(reminder: reminder, tags: extractTags(reminder.title))
                    for tag in fussyReminder.tags {
                        if tagFilter.contains(tag) {
                            delegate.fussyReminders.append(fussyReminder)
                            break
                        }
                    }
                }
                completion()
        })
    }    
}

/// Check Reminder authorization status and perform appropriate action
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
