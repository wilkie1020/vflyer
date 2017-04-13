//
//  FlyerViewController.swift
//  VFlyer
//
//  Created by Nick Kowalchuk on 2017-03-25.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import FacebookCore

class FlyerViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    //Toggles
    var likedToggle: Bool?
    var bottomHidden: Bool?
    var checkBoxHidden: Bool?
    var segueFromController: String!
    
    let dateFormatString = "MMM dd, hh:mm a"
    
    var user: User?
    var event: Event?

    override func viewWillAppear(_ animated: Bool) {
        noButton.layer.cornerRadius = 40
        yesButton.layer.cornerRadius = 40
        
        scrollView.contentSize = CGSize(width:375, height: (scrollView.contentSize.height + descriptionTextView.contentSize.height))
        
        switch bottomHidden{
        case true?:
            buttonsView.isHidden = true
            scrollView.frame.size.height += buttonsView.frame.size.height
        case false?:
            buttonsView.isHidden = false
        default:
            print("Bottom default")
        }
        
        switch checkBoxHidden{
        case true?:
            checkBoxButton.isHidden = true
        case false?:
            checkBoxButton.isHidden = false
            likedToggle = true
        default:
            print("Checkbox default")
        }
        
    }
    
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
        self.location.text = setEvent.venue
        
        //Setting up the date as a string
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        if (setEvent.startDate != setEvent.endDate)
        {
            dateString += dateFormatter.string(from: setEvent.startDate)  + " \n- "
        }
        dateString += dateFormatter.string(from: setEvent.endDate)
        
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
    
    @IBAction func unwindSegue(_ sender: Any) {
        if segueFromController == "DiscoverViewController"
        {
            self.performSegue(withIdentifier: "unwindToDiscover", sender: nil)
        }
        else if segueFromController == "MyFlyersTableViewController"
        {
            
            self.performSegue(withIdentifier: "unwindToList", sender: nil)
        }

    }

    
    //MARK: Actions
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func checkBoxTapped(_ sender: Any) {
        switch likedToggle{
        //cheked
        case true?:
            guard let user = user else {
                fatalError("User not set")
            }
            
            event?.unlikeEvent(forUser: user).then { result in
                if result {
                    print("unchecked")
                    self.likedToggle = false
                    self.checkBoxButton.setImage(#imageLiteral(resourceName: "emptyCheckBox"), for: UIControlState.normal)
                }
            }
            
        case false?:
            guard let user = user else {
                fatalError("User not set")
            }
            
            event?.likeEvent(forUser: user).then { result in
                if result {
                    print("Checked")
                    self.likedToggle = true
                    self.checkBoxButton.setImage(#imageLiteral(resourceName: "checkedBox"), for: UIControlState.normal)
                }
            }
        default:
            print("default case hit")
        }
    }
    
    @IBAction func checkPressed(_ sender: Any) {
        
        guard let user = user else {
            fatalError("User not set")
        }
        
        event?.likeEvent(forUser: user).then { result in
            if result {
                
            }
        }
        unwindSegue(sender)
        //self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func xPressed(_ sender: Any) {
        
        guard let user = user else {
            fatalError("User not set")
        }
            event?.passEvent(forUser: user).then { result in
            if result {
                
            }
        }
        unwindSegue(sender)
        //self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
