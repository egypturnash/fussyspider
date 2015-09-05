//
//  FSTask.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit
import EventKit

class FSTask: NSObject {
  var tags: [FSTag]!
  var task: EKReminder
  
  init(task: EKReminder) {
    self.task = task
    self.tags = FSTagStore.sharedInstance.extractTagsFromTitle(task.title)
  }
}
