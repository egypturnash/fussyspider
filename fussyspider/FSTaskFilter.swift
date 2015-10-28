//
//  FSTaskFilter.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/4/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit

class FSTaskFilter: NSObject {
  var showCompleted : Bool = false
  var showUntagged : Bool = true
  var sortPriority : Bool = false
  var showAll : Bool = true
  var tags : [FSTag] = []
  var filteredTasks : [FSTask] = []
  
  static let sharedInstance = FSTaskFilter()
  
  func filterTasks(tasks : [FSTask]) -> [FSTask] {
    filteredTasks = []
    
    // Filtering
    if showAll && !showCompleted && !showUntagged {
      filteredTasks = tasks
    } else {
      for task in tasks {
        if task.tags.count == 0 && !showUntagged {
          continue
        }
        if task.task.completed && !showCompleted {
          continue
        }
        if showAll {
          filteredTasks.append(task)
        } else {
          for tag in tags {
            if task.tags.contains(tag) {
              filteredTasks.append(task)
              break
            }
          }
        }
      }
    }
    
    // Sorting
    if sortPriority {
      filteredTasks.sortInPlace({ $0.task.priority < $1.task.priority })
    }
    
    return filteredTasks
  }
  
  func clear() {
    filteredTasks = []
  }
}
