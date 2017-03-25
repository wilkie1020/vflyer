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
    
    //Buttons
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    //Text/Labels
    @IBOutlet weak var flyerName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    //Photo
    @IBOutlet weak var flyerPhoto: UIImageView!
    
    
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
    
    }

    //MARK: Actions
    
    @IBAction func yesButtonPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func noButtonPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func checkButtonPressed(_ sender: Any)
    {
        
    }
    

}
