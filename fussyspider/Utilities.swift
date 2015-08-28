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

// Get EKReminders from the EventStore, extract their tags and populate .reminders[]
func fetchReminders(tagFilter : [String], completion: () -> Void) {
    
    if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        let eventStore = delegate.eventStore
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
