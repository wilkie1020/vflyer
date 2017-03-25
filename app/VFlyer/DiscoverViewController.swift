//
//  DiscoverViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-14.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    //MARK: Properties
    var user: User?
    var events = [Event]()
    var locationController = LocationController()
    //set user in the list view when segueing
    //2 strings and int. user ids and radius
    
    //Buttons

    
    //Text/Labels
    @IBOutlet weak var locationLabel: UILabel!
 
    
    //Photo

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let icon: UIImage = #imageLiteral(resourceName: "discoverIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
        
        locationController.locationManager.startUpdatingLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Functions
    func getFlyers()
    {
        if(locationController.service())
        {
        
            locationLabel.text = String(format: "location: (%0.6f, %0.6f)", locationController.returnLocation().latitude, locationController.returnLocation().longitude)
        }
        else
        {
            //pop up option to enable gps
            locationLabel.text = "Nothing"
            
            let alert = UIAlertController(title: "GPS Unavailable", message: "GPS Unavailable, enable GPS?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Settings", style: .default)
            { action in
                
                //if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                   // UIApplication.shared.openURL(settingsURL as URL)
                    
               // }
                self.dismiss(animated: true, completion: nil)
                
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default)
            { action in
                
                self.dismiss(animated: true, completion: nil)
                
            })
            self.present(alert, animated: true)
            
        }
        
    }

    //MARK: Actions
    

    

    
}
