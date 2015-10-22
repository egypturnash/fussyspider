//
//  FSTaskStore.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit
import EventKit

class FSTaskStore: NSObject {
  private var taskStore: [FSTask]!
  var finishedLoading: Bool!
  var count: Int { return taskStore.count }
  
  static let sharedInstance = FSTaskStore()
  
  override init() {
    super.init()
    taskStore = []
    checkAuthorizationStatus(EKEntityType.Reminder, authorized: loadAllTasks)
  }
  
  func taskWithTagExists(tag: FSTag) -> Bool {
    while(!finishedLoading) {}
    for task in taskStore {
      for currentTag in task.tags {
        if currentTag.title! == tag.title! {
          return true
        }
      }
    }
    return false
  }  
  
  func loadAllTasks() {
    finishedLoading = false
    taskStore = []
    
    let calendars = eventStore.calendarsForEntityType(.Reminder)
    let predicate = eventStore.predicateForRemindersInCalendars(calendars)
    
    eventStore.fetchRemindersMatchingPredicate(predicate, completion:
      { (tasks) in
        for task in tasks! {
          self.taskStore.append(FSTask(task: task))
        }
        self.finishedLoading = true
    })
  }
  
  func addTask(task: FSTask) {
    taskStore.append(task)
    do {
      try eventStore.saveReminder(task.task, commit: true)
    }
    catch let error as NSError {
      print(error)
    }
  }
  
  func deleteTask(task: FSTask) {
    taskStore.removeAtIndex(taskStore.indexOf(task)!)
    do {
      try eventStore.removeReminder(task.task, commit: true)
    }
    catch let error as NSError {
      print(error)
    }
  }
  
  func completeTask(task: FSTask) {
    task.task.completed = true
    do {
      try eventStore.saveReminder(task.task, commit: true)
    }
    catch let error as NSError {
      print(error)
    }
  }
  
  func getTaskAtIndex(row: Int) -> FSTask? {
    if row < taskStore.count {
      return taskStore[row]
    }
    return nil
  }
  
  func getAllTasks() -> [FSTask] {
    var result : [FSTask]
    loadAllTasks()
    result = []
    while(!finishedLoading) {}
    for task in taskStore {
      result.append(task)
    }
    return result
  }
}
