//
//  Date.swift
//  VFlyer
//
//  Created by Brayden Streibel on 2017-03-25.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import Foundation

extension Date {
    
    init?(iso8601String string: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
}
