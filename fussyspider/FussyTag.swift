//
//  FussyTag.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/20/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import CoreLocation

enum TagType : Int {
    case Entry = 0
    case Exit
}

class FussyTag: NSObject, NSCoding {
    var name: String!
    var location: CLLocation!
    var type: TagType!
    
    init(name: String, location: CLLocation, type: TagType = TagType.Entry) {
        self.name = name
        self.location = location
        self.type = type
    }
    
    required init?(coder decoder: NSCoder) {
        if let name = decoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
        if let location = decoder.decodeObjectForKey("location") as? CLLocation {
            self.location = location
        }
        if let type = TagType(rawValue: decoder.decodeIntegerForKey("type")) {
            self.type = type
        }
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        if let name = self.name {
            encoder.encodeObject(name, forKey: "name")
        }
        if let location = self.location {
            encoder.encodeObject(location, forKey: "location")
        }
        if let type = self.type {
            encoder.encodeInteger(type.rawValue, forKey: "type")
        }
    }
}
