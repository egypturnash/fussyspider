//
//  FussyTag.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/20/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import CoreLocation

enum tagType : Int {
    case ON_ENTRY
    case ON_EXIT
}

class FussyTag: NSObject {
    let name: String
    let location: CLLocation
    let type: tagType
    
    init(name: String, location: CLLocation, type: tagType = tagType.ON_ENTRY) {
        self.name = name
        self.location = location
        self.type = type
    }
}
