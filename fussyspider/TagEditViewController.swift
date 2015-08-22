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

    
    @IBOutlet weak var tagNameField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    // Add a radius select for the geo-fence?
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
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
            if let tagName = tagNameField!.text {
                if let location = locationManager.location {
                    let tag = FussyTag(name: tagName, location: location)
                    saveTag(tag)
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func saveTag(tag: FussyTag) {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        delegate?.fussyTags.append(tag)
    }
}
