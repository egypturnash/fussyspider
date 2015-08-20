//
//  FSReminder.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/19/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit
import EventKit

class FSReminder {
    let tags : [String]
    let reminder: EKReminder
    
    init(reminder: EKReminder, tags: [String] = []) {
        self.tags = tags
        self.reminder = reminder
    }
}
