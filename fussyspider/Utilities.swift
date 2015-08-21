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
    for slice in slices {
        if slice.substringToIndex(advance(slice.startIndex, 1)) == "#" {
            result.append(slice)
        }
    }
    return result
}

// Get EKReminders from the EventStore, extract their tags and populate .reminders[]
func fetchReminders(tagFilter : [String], completion: () -> Void) {
    var delegate : AppDelegate?
    var eventStore : EKEventStore?
    
    delegate = UIApplication.sharedApplication().delegate as? AppDelegate
    eventStore = delegate!.eventStore
    delegate!.fussyReminders = []
    
    let calendars = eventStore!.calendarsForEntityType(EKEntityType.Reminder)
    let predicate = eventStore!.predicateForRemindersInCalendars(calendars)
    
    eventStore!.fetchRemindersMatchingPredicate(predicate, completion:
        { (_reminders) in
            for reminder in _reminders! {
                let fussyReminder = FussyReminder(reminder: reminder, tags: extractTags(reminder.title))
                for tag in fussyReminder.tags {
                    if tagFilter.contains(tag) {
                        delegate!.fussyReminders.append(fussyReminder)
                        break
                    }
                }
            }
            completion()
    })
}
