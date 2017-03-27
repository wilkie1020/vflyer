//
//  SnapSlider.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-13.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
/*
 This will be the controller for one of the range sliders.
 Rounding to closests 1, 5, 10, 25, or 50km value to "snap" to it
 */
//

import UIKit

class SnapSlider: UISlider {
    
    @IBInspectable var steps: [Int] = []

}
