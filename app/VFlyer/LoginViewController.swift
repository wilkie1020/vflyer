//
//  LoginViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-05.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//
//  Description: A view controller for the login view.

import Foundation
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
        loginButton.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTriggered(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .success(_, _, _):
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DiscoverViewController") as UIViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case .failed(let errors):
                print("failed because: " + errors.localizedDescription)
            default:
                print("cancelled")
            }
        }
    }
    
}

