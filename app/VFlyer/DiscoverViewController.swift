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
 
    
    //Photo

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let icon: UIImage = #imageLiteral(resourceName: "discoverIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
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
        let endpoint = "http://159.203.7.42:8000/api/events?" + "" + user._id
        let url = URL(string: endpoint)!
        let request = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let error = error {
                    // The error should bhe extracted from it's JSON dictionary and presented to the user.
                    print ("Problems upstream. Following errors occured: " + error.localizedDescription)
                } else if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let response = json as? [[String: Any]] {
                        for item in response {
                            if let event = Event(json: item) {
                                self.events.append(event)
                            }
                        }
                    }
                }
            })
            task.resume()
        } else {
            print("Error no user ID could not get list of Events")
        }
        
    }

    //MARK: Actions
    

    

    
}
