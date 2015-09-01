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
            if mapView.selectedAnnotations.count == 1 {
                let latitude = mapView.selectedAnnotations[0].coordinate.latitude
                let longitude = mapView.selectedAnnotations[0].coordinate.longitude
                let location = CLLocation(latitude: latitude, longitude: longitude)
                var tagType : FussyTag.TagType
                
                if let tagName = tagNameField!.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()) {
                    let slices = tagName.componentsSeparatedByString(" ")
                    if slices.count > 1 {
                        print("Multiple words for tag, only first is used!")
                    }
                    if onEntrySwitch.on && onExitSwitch.on {
                        tagType = .Both
                    } else if onEntrySwitch.on {
                        tagType = .Entry
                    } else {
                        tagType = .Exit
                    }
                    let radius = radiusSlider.value
                    let tag = FussyTag(name: slices[0], location: location, type: tagType, radius: radius)
                    saveTag(tag)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Please select one location", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
                    print("Alert closed")
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)                
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func saveTag(tag: FussyTag) {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            for possibleUpdate in delegate.fussyTags {
                if possibleUpdate.name == tag.name {
                    delegate.fussyTags.removeAtIndex(delegate.fussyTags.indexOf(possibleUpdate)!)
                }
            }
            delegate.fussyTags.append(tag)
            delegate.saveAllFussyTags()
            delegate.registerFenceForTag(tag)
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
                print("Error: \(error!.localizedDescription)")
            } else if response != nil {
                if response!.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    
                    for item in response!.mapItems {
                        print("Name = \(item.name)")
                        
                        self.matchingItems.append(item as MKMapItem)
                        print("Matching items = \(self.matchingItems.count)")
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
    }
}
