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

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if the user is already logged in then no need to create loggin button.
        if AccessToken.current != nil {
            //segue to the discover page.
            performSegue(withIdentifier: "loginSegue", sender: nil)
        } else {
            //Creates Facebook login button at center of the screen.
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
            
            view.addSubview(loginButton)
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .success(_, _, _):
            performSegue(withIdentifier: "loginSegue", sender: nil)
        case .failed(let errors):
            print("failed because: " + errors.localizedDescription)
        default:
            print("cancelled")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let discoverViewController = segue.destination as? DiscoverViewController {
            if let accessToken = AccessToken.current {
                //Unwraps the userId. If there is not user ID something is wrong. Otherwise, query the API for the user associated with that userId.
                if let userId = accessToken.userId {
                    let user = User(userId: userId)
                    user.login().then(success: {
                        discoverViewController.user?._id = user._id
                        discoverViewController.user?.userId = user.userId
                        discoverViewController.user?.radius = user.radius
                    })
                } else {
                    print("Error acessToken has no userId")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

