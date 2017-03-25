//
//  User.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-12.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import os.log

class User {
    //MARK: Properties
    var _id: String?
    var userId: String
    var radius: Int?
    var events = [Event]()
    
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
    
    let BASE_URL = URL(string: "http://159.203.7.42:8000/api/users/")
    
    // MARK: Methods
    public func login() -> Promise {
        let p = Promise.defer()
        
        let url = URL(string: "login?fbUserId=\(userId)", relativeTo: BASE_URL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let error = error {
                // The error should bhe extracted from it's JSON dictionary and presented to the user.
                print ("Problems upstream. Following errors occured: " + error.localizedDescription)
                p.reject()
            } else if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = json as? [String: Any] {
                    self._id = response["_id"] as! String
                    self.userId = response["userId"] as! String
                    self.radius = response["radius"] as! Int
                }
                p.resolve()()
            }
        })
        task.resume()
        
        return p
    }
}
