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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func snap() -> Float
    {
       return round(value: self.value)
    }
    
    func round(value: Float) -> Float
    {
        
        if((value > 1) && (value <= 5))
        {
            if( value == 1)
            {
                return 1
            }
            else
            {
                
                let mid: Float = 3
                
                if(value < mid)
                {
                    return 1
                }
                else
                {
                    return 5
                }
                
            }
        }
        else if((value > 5) && (value <= 10))
        {
            if( value == 10)
            {
                return 10
            }
            else
            {
                
                let mid: Float = 15/2
                
                if(value < mid)
                {
                    return 5
                }
                else
                {
                    return 10
                }
                
            }
        }
        else if((value > 10) && (value <= 25))
        {
            if( value == 25)
            {
                return 25
            }
            else
            {
                
                let mid: Float = 35/2
                
                if(value < mid)
                {
                    return 10
                }
                else
                {
                    return 25
                }
                
            }
        }
        else if((value > 25) && (value <= 50))
        {
            if( value == 50)
            {
                return 50
            }
            else
            {
                
                let mid: Float = 75/2
                
                if(value < mid)
                {
                    return 25
                }
                else
                {
                    return 50
                }
                
            }
        }
        else if((value > 50) && (value <= 100))
        {
            if( value == 100)
            {
                return 100
            }
            else
            {
                
                let mid: Float = 75
                
                if(value < mid)
                {
                    return 50
                }
                else
                {
                    return 100
                }
                
            }
        }
        else //simple a fail safe. Logic should be fine.
        {
            return 1
        }
        
    }

}
