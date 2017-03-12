//
//  Flyer.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-09.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import os.log

class Flyer {
    //MARK: Properties
    var id: Int
    var name: String
    var picture: UIView
    var description: (summary: String, location: String)
    var startDate: Date
    var endDate: Date
    
    //MARK: Initialization
    init?(id: Int, name: String, picture: UIView, description: (summary: String, location: String), startDate: Date, endDate: Date) {
        self.id = id
        self.name = name
        self.picture = picture
        self.description.summary = description.summary
        self.description.location = description.location
        self.startDate = startDate
        self.endDate = endDate
    }
}
