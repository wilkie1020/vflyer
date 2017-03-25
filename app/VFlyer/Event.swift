//
// Event.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-09.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import os.log

class Event {
    //MARK: Properties
    var _id: String
    var name: String
    //var picture: UIView
    var description: String
    var startDate: Date
    var endDate: Date
    
    //MARK: Initialization
    init?(id: String, name: String, picture: UIView, description: String, startDate: Date, endDate: Date) {
        self._id = id
        self.name = name
        //self.picture = picture
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init?(json: [String: Any]) {
        guard
            let _id = json["_id"] as? String,
            let name = json["name"] as? String,
            let description = json["description"] as? String,
            let startDate = json["startDate"] as? Date,
            let endDate = json["endDate"] as? Date
            else {
                return nil
        }
        
        self._id = _id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate

    }

}
