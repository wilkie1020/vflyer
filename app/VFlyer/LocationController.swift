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
    
    override init()
    {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        
    }
    
    func returnLocation(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> CLLocationCoordinate2D
    {
        
        return (locations.last?.coordinate)!
    }
    
}
