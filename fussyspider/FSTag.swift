//
//  FSTag.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import CoreLocation
import MapKit

let FSTagTitleKey = "title"
let FSTagLatitudeKey = "latitude"
let FSTagLongitudeKey = "longitude"
let FSTagTypeKey = "type"
let FSTagRadiusKey = "radius"

enum TagType : Int {
  case Entry = 0
  case Exit
  case Both
}

class FSTag: NSObject, NSCoding, MKAnnotation {
  var title: String?
  var coordinate: CLLocationCoordinate2D
  var type: TagType
  var radius: CLLocationDistance
  
  var subtitle: String? {
    return "subtitle"
  }
  
  init(title: String, coordinate: CLLocationCoordinate2D, type: TagType = .Exit, radius: CLLocationDistance = CLLocationDistance(50.0)) {
    self.title = title
    self.coordinate = coordinate
    self.type = type
    self.radius = radius
  }
  
  // MARK: NSCoding
  
  required init?(coder decoder: NSCoder) {
    self.title = decoder.decodeObjectForKey(FSTagTitleKey) as? String
    let longitude = decoder.decodeDoubleForKey(FSTagLongitudeKey)
    let latitude = decoder.decodeDoubleForKey(FSTagLatitudeKey)
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    self.type = TagType(rawValue: decoder.decodeIntegerForKey(FSTagTypeKey))!
    self.radius = decoder.decodeObjectForKey(FSTagRadiusKey) as! CLLocationDistance
  }
  
  func encodeWithCoder(encoder: NSCoder) {
    encoder.encodeObject(self.title, forKey: FSTagTitleKey)
    encoder.encodeDouble(self.coordinate.latitude, forKey: FSTagLatitudeKey)
    encoder.encodeDouble(self.coordinate.longitude, forKey: FSTagLongitudeKey)
    encoder.encodeInteger(self.type.rawValue, forKey: FSTagTypeKey)
    encoder.encodeObject(self.radius, forKey: FSTagRadiusKey)
  }
}
