//
//  LoginViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-05.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//
//  Description: A view controller for the login view.

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //if the user is already logged in then no need to create loggin button.
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            
            //TODO: Add segue into app.
        } else {
            //Creates Facebook login button at center of the screen.
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
        
            view.addSubview(loginButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

