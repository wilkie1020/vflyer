//
//  OverlayView.swift
//  VFlyer
//
//  Created by Brayden Streibel on 2017-03-28.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import Foundation
import UIKit

enum GGOverlayViewMode {
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}

class OverlayView: UIView {
    var _mode: GGOverlayViewMode! = GGOverlayViewMode.GGOverlayViewModeLeft
    var imageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        imageView = UIImageView(image: #imageLiteral(resourceName: "cross"))
        self.addSubview(imageView)
    }
    
    func setMode(mode: GGOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode
        
        if _mode == GGOverlayViewMode.GGOverlayViewModeLeft {
            imageView.image = #imageLiteral(resourceName: "cross")
            self.backgroundColor = UIColor.red
        } else {
            imageView.image = #imageLiteral(resourceName: "check")
            self.backgroundColor = UIColor.green
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
    }
}
