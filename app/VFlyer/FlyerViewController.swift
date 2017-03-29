//
//  FlyerViewController.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-25.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import FacebookCore

class FlyerViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var eventImage: UIImageView!
    
    var user: User?
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current == nil {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        guard let setEvent = event else {
            fatalError("No event to display");
        }
        
        self.name.text = setEvent.name
        //self.location = setEvent.location
        //TODO: get the location
        
        //Setting up the date as a string
        var dateString = ""
        if (setEvent.startDate != setEvent.endDate)
        {
            dateString += setEvent.startDate.description + " - "
        }
        dateString += setEvent.endDate.description
        
        self.date.text = dateString
        self.descriptionTextView.text = setEvent.description
        self.eventImage.image = setEvent.image

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Actions
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
