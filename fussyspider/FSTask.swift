//
//  FSTask.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit
import EventKit

class FSTask: EKReminder {
    var tags: [FSTag]!
    
    init(task: EKReminder) {
        super.init()
        self.tags = extractTags(task.title)
    }
}
