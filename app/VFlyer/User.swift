//
//  User.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-12.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import CoreLocation

class User {
    //MARK: Properties
    var _id: String?
    var userId: String
    var radius: Int?
    var likedEvents = [Event]()
    
    var json: [String: Any] {
        return [
            "_id": self._id!,
            "userId": self.userId,
            "radius": self.radius!
        ]
    }
    
    //MARK: Initialization
    init(userId: String) {
        self.userId = userId
    }
    
    init?(json: [String: Any]) {
        guard
            let _id = json["_id"] as? String,
            let userId = json["userId"] as? String,
            let radius = json["radius"] as? Int
            else {
                return nil
        }
        
        self._id = _id;
        self.userId = userId;
        self.radius = radius;
    }
    
    let BASE_URL = URL(string: "http://159.203.7.42:8000/api/")
    
    // MARK: Methods
    
    public func save() -> Promise<Bool> {
        guard let reqBody = try? JSONSerialization.data(withJSONObject: self.json, options: []) else {
            fatalError("Something has gone horribly wrong.")
        }
        
        let url = URL(string: "users/\(_id!)", relativeTo: BASE_URL)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        print("PUT \(url.absoluteURL)")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return Promise<Bool>(work: { fulfill, reject in
            session.uploadTask(with: request, from: reqBody, completionHandler: { data, response, error in
                if let error = error {
                    reject(error)
                } else if let _ = data, let response = response as? HTTPURLResponse {
                    fulfill(response.statusCode == 200)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }).resume()
        })
    }
    
    public func delete() -> Promise<Bool> {

        let url = URL(string: "users/\(_id!)", relativeTo: BASE_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        print("DELETE \(url.absoluteURL)")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return Promise<Bool>(work: { fulfill, reject in
            session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    reject(error)
                } else if let _ = data, let response = response as? HTTPURLResponse {
                    fulfill(response.statusCode == 200)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }).resume()
        })
    }
    
    public func login() -> Promise<Void> {
        // Check if user already logged in
        if _id == nil {
            let url = URL(string: "users/login?fbUserId=\(userId)", relativeTo: BASE_URL)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            print("POST \(url.absoluteURL)")
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            return Promise<Void>(work: { fulfill, reject in
                session.dataTask(with: request, completionHandler: { data, response, error in
                    if let error = error {
                        reject(error)
                    } else if let data = data, let _ = response as? HTTPURLResponse {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let response = json as? [String: Any] {
                            self._id = response["_id"] as! String
                            self.userId = response["userId"] as! String
                            self.radius = response["radius"] as! Int
                        }
                        fulfill()
                    } else {
                        fatalError("Something has gone horribly wrong.")
                    }
                }).resume()
            })
        } else {
            return Promise<Void>(work: {fulfill, _ in
                fulfill()
            })
        }
    }
    
    public func loadLikedEvents() -> Promise<[Event]> {
        let url = URL(string: "users/\(_id!)/liked", relativeTo: BASE_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print("GET \(url.absoluteURL)")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return Promise<[Event]>(work: { fulfill, reject in
            session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    reject(error)
                } else if let data = data, let _ = response as? HTTPURLResponse {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    var events = [Event]()
                    if let response = json as? [[String: Any]] {
                        for item in response {
                            if let event = Event(json: item) {
                                events.append(event)
                            }
                        }
                    }
                    self.likedEvents = events;
                    fulfill(events)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }).resume()
        })
    }
    
    public func discoverEvents(coordinates:CLLocationCoordinate2D) -> Promise<[Event]> {
        
        let lat = coordinates.latitude
        let lon = coordinates.longitude
        
        let url = URL(string: "events?lat=\(lat)&lon=\(lon)&userId=\(_id!)", relativeTo: BASE_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print("GET \(url.absoluteURL)")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return Promise<[Event]>(work: { fulfill, reject in
            session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    reject(error)
                } else if let data = data, let _ = response as? HTTPURLResponse {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    var events = [Event]()
                    if let response = json as? [[String: Any]] {
                        for item in response {
                            if let event = Event(json: item) {
                                events.append(event)
                            }
                        }
                    }
                    fulfill(events)
                } else {
                    fatalError("Something has gone horribly wrong.")
                }
            }).resume()
        })
    }

}
