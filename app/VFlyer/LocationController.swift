//
//  LocationController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-25.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationControllerDelegate {
    func locationDidUpdate(location: CLLocation?)
}

class LocationController: NSObject, CLLocationManagerDelegate{
    
    static let SharedManager = LocationController()
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var locations: [CLLocation]?
    
    var delegate : LocationControllerDelegate?
    
    override init() {
        super.init()
        self.location = nil
        self.locationManager.delegate = self
    }
    
    func start() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func service() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            return true
        }
        else {
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locations = locations
        if(locations.last != nil) {
            self.location = (locations.last?.coordinate)!
            self.delegate?.locationDidUpdate(location: (locations.last)!)
            
        } else {
            self.location = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
        
    }
    

    
}
