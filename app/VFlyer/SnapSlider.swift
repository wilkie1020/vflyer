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
        
        if((value > 1) && (value <= 16.5))
        {
            if( value == 1)
            {
                return 1
            }
            else
            {
                
                let mid: Float = (1 + 16.5)/2
                
                if(value < mid)
                {
                    return 1
                }
                else
                {
                    return 16.5
                }
                
            }
        }
        else if((value > 16.5) && (value <= 33))
        {
            if( value == 33)
            {
                return 33
            }
            else
            {
                
                let mid: Float = (16.5 + 33)/2
                
                if(value < mid)
                {
                    return 16.5
                }
                else
                {
                    return 33
                }
                
            }
        }
        else if((value > 33) && (value <= 49.5))
        {
            if( value == 49.5)
            {
                return 49.5
            }
            else
            {
                
                let mid: Float = (33 + 49.5)/2
                
                if(value < mid)
                {
                    return 33
                }
                else
                {
                    return 49.5
                }
                
            }
        }
        else if((value > 49.5) && (value <= 66))
        {
            if( value == 66)
            {
                return 66
            }
            else
            {
                
                let mid: Float = (49.5 + 66)/2
                
                if(value < mid)
                {
                    return 49.5
                }
                else
                {
                    return 66
                }
                
            }
        }
        else if((value > 66) && (value <= 82.5))
        {
            if( value == 82.5)
            {
                return 82.5
            }
            else
            {
                
                let mid: Float = (66 + 82.5)/2
                
                if(value < mid)
                {
                    return 66
                }
                else
                {
                    return 82.5
                }
                
            }
        }
        else if((value > 82.5) && (value <= 100))
        {
            if( value == 100)
            {
                return 100
            }
            else
            {
                
                let mid: Float = (100 + 82.5)/2
                
                if(value < mid)
                {
                    return 82.5
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
