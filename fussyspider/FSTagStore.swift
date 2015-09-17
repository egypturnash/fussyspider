//
//  FSTagStore.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import EventKit

let FSTagStoreKey = "tagstore"

class FSTagStore: NSObject {
  private var tagStore: [FSTag] = []
  var finishedLoading : Bool!
  var count: Int { return tagStore.count }
  
  static let sharedInstance = FSTagStore()
  
  override init() {
    super.init()
    loadAllTags()
  }
  
  func addTag(tag: FSTag) {
    while !finishedLoading {}
    if let title = tag.title {
      if let foundTag = getTagWithTitle(title) {
        if let index = tagStore.indexOf(foundTag) {
          tagStore.removeAtIndex(index)
          tagStore.insert(tag, atIndex: index)
        }
      } else {
        tagStore.append(tag)
      }
      saveAllTags()
    }
  }
  
  func removeTagWithTitle(title: String) {
    if let deletedTag = getTagWithTitle(title) {
      tagStore.removeAtIndex(tagStore.indexOf(deletedTag)!)
      saveAllTags()
    }
  }
  
  func getTagWithTitle(title: String) -> FSTag? {
    for tag in tagStore {
      if tag.title == title {
        return tag
      }
    }
    return nil
  }
  
  func getTagAtIndex(row: Int) -> FSTag? {
    if row < tagStore.count {
      return tagStore[row]
    }
    return nil
  }
  
  func getAllTags() -> [FSTag] {
    var result : [FSTag]
    result = []
    for tag in tagStore {
      result.append(tag)
    }
    return result
  }
  
  func getIndexOfTag(tag: FSTag) -> Int! {
    return tagStore.indexOf(tag)
  }
  
  func extractTagsFromTitle(title: String) -> [FSTag] {
    while !finishedLoading {}
    var result : [FSTag] = []
    
    let words = title.componentsSeparatedByString(" ")
    for var word in words {
      if word != "" {
        let firstChar = word.substringToIndex(word.startIndex.advancedBy(1))
        if firstChar == "#" {
          word.removeAtIndex(word.startIndex)
          if let tag = getTagWithTitle(word) {
            result.append(tag)
          } else {
            let tag = FSTag(title: word,
              coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            result.append(tag)
            addTag(tag)
          }
        }
      }
    }
    return result
  }
  
  func loadAllTags() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    tagStore = []
    finishedLoading = false
    if let tags = userDefaults.arrayForKey(FSTagStoreKey)
    {
      for tag in tags {
        if let currentTag = NSKeyedUnarchiver.unarchiveObjectWithData(tag as! NSData) as? FSTag {
          tagStore.append(currentTag)
        }
      }
    }
    finishedLoading = true
  }
  
  func saveAllTags() {
    while !finishedLoading {}
    finishedLoading = false
    let tags = NSMutableArray()
    for currentTag in tagStore {
      let tag = NSKeyedArchiver.archivedDataWithRootObject(currentTag)
      tags.addObject(tag)
    }
    NSUserDefaults.standardUserDefaults().setObject(tags, forKey: FSTagStoreKey)
    NSUserDefaults.standardUserDefaults().synchronize()
    finishedLoading = true
  }
}
