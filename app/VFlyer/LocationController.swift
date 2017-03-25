//
//  LocationController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-25.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    override init()
    {
        super.init()
        location = nil
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
    }
    
    func service() -> Bool
    {
        if CLLocationManager.locationServicesEnabled()
        {
            return true
        }
        else { return false }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        if(locations.last != nil)
        {
            location = (locations.last?.coordinate)!
        }
        else
        {
            location = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
        
    }
    
 
    func returnLocation() -> CLLocationCoordinate2D
    {
  
            return location!
    }
    
}
