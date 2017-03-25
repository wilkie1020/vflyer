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
    var radius: Int
    
    //MARK: Initialization
    init?(userId: String, radius: Int) {
        self.userId = userId
        self.radius = radius
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
}
