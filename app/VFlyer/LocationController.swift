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
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        <#code#>
    }
    
    func returnLocation() -> CLLocationCoordinate2D
    {
        
        return location!
    }
    
}
