//
//  TagEditViewController.swift
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TagEditViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  
  var matchingItems: [MKMapItem] = [MKMapItem]()
  let locationManager = CLLocationManager()
  let tagStore = FSTagStore()
  
  @IBOutlet weak var tagNameField: UITextField!
  @IBOutlet weak var locationNameField: UITextField!
  @IBOutlet weak var onEntrySwitch: UISwitch!
  @IBOutlet weak var onExitSwitch: UISwitch!
  @IBOutlet weak var radiusSlider: UISlider!
  @IBOutlet weak var mapView: MKMapView!
  
  @IBAction func locationFieldReturn(sender: AnyObject) {
    sender.resignFirstResponder()
    mapView.removeAnnotations(mapView.annotations)
    self.performSearch()
  }
  
  @IBAction func zoomToUser(sender: AnyObject) {
    if let coordinate = mapView.userLocation.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coordinate, 30000, 30000)
      mapView.setRegion(region, animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    mapView.showsUserLocation = (status == .AuthorizedAlways)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Save selected
    if sender!.tag == 1 {
      if tagTitle != nil {
        tagStore.addTag(FSTag(title: tagTitle,
          coordinate: tagCoordinate,
          type: tagType,
          radius: tagRadius))
        tagStore.saveAllTags()
      }
      else {
        let alert = FSAlertController(title: "Warning", message: "No tag name entered.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
      }
    }
  }
  
  func performSearch() {
    matchingItems.removeAll()
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = locationNameField.text
    request.region = mapView.region
    
    let search = MKLocalSearch(request: request)
    
    search.startWithCompletionHandler({(response:
      MKLocalSearchResponse?,
      error: NSError?) in
      
      if error != nil {
        let alert = FSAlertController(title: "Search", message: "No results found", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
      } else if response != nil {
        for item in response!.mapItems {
          self.matchingItems.append(item as MKMapItem)
          
          let annotation = MKPointAnnotation()
          annotation.coordinate = item.placemark.coordinate
          annotation.title = item.name
          
          self.mapView.addAnnotation(annotation)
        }
      }
    })
  }
  
  var tagTitle : String! {
    if let trimmedInput = tagNameField!.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()) {
      let slicedInputArray = trimmedInput.componentsSeparatedByString(" ")
      if slicedInputArray.count > 1 {
        let alert = FSAlertController(title: "Warning", message: "Multiple words entered, only first used.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
      }
      if slicedInputArray[0] == "" {
        return nil
      }
      return slicedInputArray[0]
    }
    return nil
  }
  
  var tagCoordinate : CLLocationCoordinate2D {
    if mapView.selectedAnnotations.count == 1 {
      let latitude = mapView.selectedAnnotations[0].coordinate.latitude
      let longitude = mapView.selectedAnnotations[0].coordinate.longitude
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    return CLLocationCoordinate2D(latitude: 90.0, longitude: 0.0)
  }
  
  var tagType : TagType {
    if onEntrySwitch.on && onExitSwitch.on {
      return .Both
    } else if onEntrySwitch.on {
      return .Entry
    } else {
      return .Exit
    }
  }
  
  var tagRadius : CLLocationDistance! {
    return CLLocationDistance(radiusSlider.value)
  }
}
