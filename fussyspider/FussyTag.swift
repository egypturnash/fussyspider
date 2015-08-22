//
//  FussyTag.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/20/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import CoreLocation

/// Location-based tag with serialization
class FussyTag: NSObject, NSCoding {
    
    /// The tag name
    var name: String!
    
    /// The location associated with this tag
    var location: CLLocation!
    
    /// The tag notification type
    var type: TagType!
    
    /**
    Location-based notification type
    
    - Entry: Notification on entry of location
    - Exit: Notification on exit of location
    */
    enum TagType : Int {
        case Entry = 0
        case Exit
    }
    
    /**
        Initializes a new FussyTag
    
        :param: name The name of the tag
        :param: location The location of the tag
        :param: type The notification type of the tag
    */
    init(name: String, location: CLLocation, type: TagType = TagType.Entry) {
        self.name = name
        self.location = location
        self.type = type
    }
    
    
    //
    // MARK: NSCoding
    
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
