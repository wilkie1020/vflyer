//
//  DiscoverViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-14.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import CoreLocation

class DiscoverViewController: UIViewController, LocationControllerDelegate {

    //MARK: Properties
    var user: User?
    var locationController = LocationController()
    var coord = CLLocationCoordinate2D()
    var eventsIndex = 0
    
    //Buttons
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

    
    //Text/Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
 
    
    //Photo
    @IBOutlet weak var eventPhoto: UIImageView!
    //Tap Gesture
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let icon: UIImage = #imageLiteral(resourceName: "discoverIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
        
        locationController.delegate = self
        
        getFlyers()
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
        
            user?.discoverEvents(coordinates: coord).then({ events in
                print("Discovered events for user: \(events.count)")
                for event in events {
                    print("Name: \(event.name)")
                    
                }
            })
            
            nameLabel.text = user?.likedEvents[0].name
            //locationLabel.text = user?.likedEvents[0].
            //dateTimeLabel.text = String(format: "DD/MM/YY", user?.likedEvents[0].startDate)
            
        }
        else
        {
            //pop up option to enable gps
            locationLabel.text = "Nothing"
            
            let alert = UIAlertController(title: "GPS Unavailable", message: "GPS Unavailable, enable GPS?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Settings", style: .default)
            { action in
                
                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                    UIApplication.shared.openURL(settingsURL as URL)
                    
               }
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
    
    @IBAction func listButtonPressed(_ sender: UIBarButtonItem) {
        print("\n\n listButtonPressed function called")
        print(user?.userId)
        user?.loadLikedEvents().then({_ in
            print("\n\n events loaded \n\n")
            self.performSegue(withIdentifier: "discoverToList", sender: nil)
        })
    }
    
    

    
    func locationDidUpdate(location: CLLocation?)
    {
        if(location != nil)
        {
            coord = (location?.coordinate)!
        }
        else
        {
            coord = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }

    
    @IBAction func tapped(_ sender: Any)
    {
        
    }
    
}
