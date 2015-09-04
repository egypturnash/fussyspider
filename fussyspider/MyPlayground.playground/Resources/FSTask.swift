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
    
    func extractTags(input: String) -> [FSTag] {
        var result : [FSTag] = []
        let tagStore = FSTagStore.sharedInstance
        
        let slices = input.componentsSeparatedByString(" ")
        for var slice in slices {
            if slice != "" {
                let first = slice.substringToIndex(advance(slice.startIndex, 1))
                if first == "#" {
                    slice.removeAtIndex(slice.startIndex)
                    if let tag = tagStore.getTagWithTitle(slice) {
                        result.append(tag)
                    } else {
                        let tag = FSTag(title: slice,
                            coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
                        result.append(tag)
                        tagStore.addTag(tag)
                    }
                }
            }
        }
        return result
    }
}
