//
//  EventView.swift
//  VFlyer
//
//  Created by Brayden Streibel on 2017-03-27.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit

@IBDesignable class EventView: UIView {
    
    // Our custom view from the XIB file
    var view: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBInspectable var event: Event? {
        get {
            return self.event;
        }
        set(event) {
            nameLabel.text = event?.name
            imageView.image = event?.image
            dateLabel.text = "\(event?.startDate) - \(event?.endDate)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        //Figure out why this isn't working
//        view.layer.masksToBounds = false
//        view.layer.cornerRadius = 8
//        view.layer.shadowOffset = CGSize(width: 0, height: 5)
//        view.layer.shadowRadius = 5
//        view.layer.shadowOpacity = 0.5
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EventView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
