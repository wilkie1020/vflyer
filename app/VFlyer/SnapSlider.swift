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
        
        if((value > 1) && (value <= 20))
        {
            if( value == 1)
            {
                return 1
            }
            else
            {
                
                let mid: Float = (1 + 20)/2
                
                if(value < mid)
                {
                    return 1
                }
                else
                {
                    return 20
                }
                
            }
        }
        else if((value > 20) && (value <= 40))
        {
            if( value == 40)
            {
                return 40
            }
            else
            {
                
                let mid: Float = (60)/2
                
                if(value < mid)
                {
                    return 20
                }
                else
                {
                    return 40
                }
                
            }
        }
        else if((value > 40) && (value <= 60))
        {
            if( value == 60)
            {
                return 60
            }
            else
            {
                
                let mid: Float = (60 + 40)/2
                
                if(value < mid)
                {
                    return 40
                }
                else
                {
                    return 60
                }
                
            }
        }
        else if((value > 60) && (value <= 80))
        {
            if( value == 66)
            {
                return 66
            }
            else
            {
                
                let mid: Float = (60 + 80)/2
                
                if(value < mid)
                {
                    return 60
                }
                else
                {
                    return 80
                }
                
            }
        }
        else if((value > 80) && (value <= 100))
        {
            if( value == 100)
            {
                return 100
            }
            else
            {
                
                let mid: Float = (80 + 100)/2
                
                if(value < mid)
                {
                    return 80
                }
                else
                {
                    return 100
                }
                
            }
        }
            //simple a fail safe. Logic should be fine.
        else
        {
            return 1
        }
        
    }

}
