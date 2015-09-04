//
//  FSTagStore.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import EventKit

let FSTagStoreKey = "tagstore"

class FSTagStore: NSObject, NSCoding {
    private var tagStore: [FSTag]
    
    static let sharedInstance = FSTagStore()
    
    override init() {
        tagStore = []
    }
    
    func addTag(tag: FSTag) {
        if let title = tag.title {
            if getTagWithTitle(title) == nil {
                tagStore.append(tag)
            }
        }
    }
    
    func removeTagWithTitle(title: String) {
        if let deletedTag = getTagWithTitle(title) {
            tagStore.removeAtIndex(tagStore.indexOf(deletedTag)!)
        }
    }
    
    func getTagWithTitle(title: String) -> FSTag! {
        for tag in tagStore {
            if tag.title == title {
                return tag
            }
        }
        return nil
    }
    
    func extractTagsFromTitle(title: String) -> [FSTag] {
        var result : [FSTag] = []
        
        let words = title.componentsSeparatedByString(" ")
        for var word in words {
            if word != "" {
                let firstChar = word.substringToIndex(advance(word.startIndex, 1))
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
    
    // MARK: NSCoding
    
    required init?(coder decoder: NSCoder) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        tagStore = []
        
        if let tags = userDefaults.arrayForKey(FSTagStoreKey)
        {
            for tag in tags {
                if let currentTag = NSKeyedUnarchiver.unarchiveObjectWithData(tag as! NSData) as? FSTag {
                    tagStore.append(currentTag)
                }
            }
        }
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        let tags = NSMutableArray()
        for currentTag in tagStore {
            let tag = NSKeyedArchiver.archivedDataWithRootObject(currentTag)
            tags.addObject(tag)
        }
        NSUserDefaults.standardUserDefaults().setObject(tags, forKey: FSTagStoreKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
