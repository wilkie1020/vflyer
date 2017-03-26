//
//  DiscoverViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-14.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookCore

class DiscoverViewController: UIViewController, LocationControllerDelegate {

    //MARK: Properties
    var user: User?
    var events: [Event]?
    var locationController = LocationController()
    var coord = CLLocationCoordinate2D()
    var eventsIndex = 0
    
    //Buttons
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon: UIImage = #imageLiteral(resourceName: "discoverIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
        
        locationController.delegate = self
        
        guard let accessToken = AccessToken.current else {
            fatalError("AccessToken is not set");
        }

        if let userId = accessToken.userId {
            user = User(userId: userId)
            user?.login().then({
                let test = "_id: \(self.user?._id)\nuserId: \(self.user?.userId)\nradius: \(self.user?.radius)\n"
                print(test)
                self.getFlyers()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noButton.layer.cornerRadius = 40
        yesButton.layer.cornerRadius = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Sets navVC to be the destination of the segue which should be the Navigation controller of discover.
        //since Discover only segues to nav controllers, if this doesn't work an error occured.
        guard let navVC = segue.destination as? UINavigationController else {
            fatalError("Unexpected destination: \(segue.destination)");
        }
        
        switch(segue.identifier ?? "") {
        case "discoverToList":
            //Sets discoverVC to be the first viewController on the navigation stack. This should be the Disocver view.
            //If unable to set this a fatal error occured.
            guard let discoverVC = navVC.viewControllers.first as? MyFlyersTableViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            //sets the user at the discover page before seguingfatalError("Unexpected destination: \(navVC.viewControllers.first)");
            discoverVC.user = self.user
        case "discoverToSettings":
            //print("segue to settings")
            guard let settingsVC = navVC.viewControllers.first as? SettingsViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            let icon: UIImage = #imageLiteral(resourceName: "discoverIcon")
            settingsVC.backButton.image = icon
            settingsVC.user = self.user
            
        case "settingsToDiscover":
            print("settingstodiscover segue")
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)");
        }

    }
    
    
    //University lat 50.418034, long -104.590338
    //MARK: Functions
    func getFlyers() {
        if(locationController.service()) {
            user?.discoverEvents(coordinates: coord).then({ events in
                print("Discovered events for user: \(events.count)")
                self.events = events
            })
        } else {
            //pop up option to enable gps
            let alert = UIAlertController(title: "GPS Unavailable", message: "GPS Unavailable, enable GPS?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { action in
                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                    UIApplication.shared.openURL(settingsURL as URL)
                }
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true)
        }
        
    }
    
    //MARK: Actions
    
    @IBAction func noButtonTriggered(_ sender: UIButton) {
        print("No")
        events?.removeFirst()
        print("Events count: \(events!.count)")
    }
    
    @IBAction func yesButtonTriggered(_ sender: UIButton) {
        print("Yes")
        events?.removeFirst()
        print("Events count: \(events!.count)")
    }
    
    @IBAction func listButtonPressed(_ sender: UIBarButtonItem) {
        user?.loadLikedEvents().then({_ in
            self.performSegue(withIdentifier: "discoverToList", sender: nil)
        })
    }
    
    func locationDidUpdate(location: CLLocation?) {
        if(location != nil) {
            coord = (location?.coordinate)!
        } else {
            coord = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }

    @IBAction func tapped(_ sender: Any) {
        
    }
    
}
