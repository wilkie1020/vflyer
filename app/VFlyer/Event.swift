//
// Event.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-09.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit

class Event {
    //MARK: Properties
    var _id: String
    var name: String
    var image: UIImage
    var description: String
    var venue: String
    var startDate: Date
    var endDate: Date
    
    //MARK: Initialization
    init?(id: String, name: String, image: UIImage, description: String, startDate: Date, endDate: Date, venue: String) {
        self._id = id
        self.name = name
        self.image = image
        self.description = description
        self.venue = venue
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init?(json: [String: Any]) {
        guard
            let _id = json["_id"] as? String,
            let name = json["name"] as? String,
            let description = json["description"] as? String,
            let venue = json["venue"] as? String,
            let startDateString = json["startDate"] as? String,
            let startDate = Date(iso8601String: startDateString),
            let endDateString = json["endDate"] as? String,
            let endDate = Date(iso8601String: endDateString)
        else {
            return nil
        }
        
        if let strBase64 = json["image"] as? String {
            let decodedImage = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
            self.image = UIImage(data: decodedImage)!
        } else {
            self.image = #imageLiteral(resourceName: "defaultPhoto")
        }
        
        self._id = _id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.venue = venue
    }
    
    // MARK: Methods
    
    let BASE_URL = URL(string: "http://159.203.7.42:8000/api/")
    
    public func likeEvent(forUser user:User) -> Promise<Bool> {
        let url = URL(string: "users/\(user._id!)/liked?eventId=\(_id)", relativeTo: BASE_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("POST \(url.absoluteURL)")
        
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
    
    public func unlikeEvent(forUser user:User) -> Promise<Bool> {
        let url = URL(string: "users/\(user._id!)/liked?eventId=\(_id)", relativeTo: BASE_URL)!
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
    
    public func passEvent(forUser user:User) -> Promise<Bool> {
        let url = URL(string: "users/\(user._id!)/viewed?eventId=\(_id)", relativeTo: BASE_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("POST \(url.absoluteURL)")
        
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
}
