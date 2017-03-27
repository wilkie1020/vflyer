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
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current == nil {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }

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
