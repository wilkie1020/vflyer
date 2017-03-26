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
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        //Sets navVC to be the destination of the segue which should be the Navigation controller of discover.
//        //if for some reason this didn't work then an error has occured.
//        guard let navVC = segue.destination as? UINavigationController else {
//            fatalError("Unexpected destination: \(segue.destination)");
//        }
//        //Sets discoverVC to be the first viewController on the navigation stack. This should be the Disocver view.
//        //If unable to set this a fatal error occured.
//        guard let discoverVC = navVC.viewControllers.first as? DiscoverViewController else {
//            fatalError("Unexpected destination: \(navVC.viewControllers.first)");
//        }
//        
//        //Unwraps the userId. If there is not user ID something is wrong. Otherwise, query the API for the user associated with that userId.
//        guard let accessToken = AccessToken.current else {
//            fatalError("AccessToken is not set");
//        }
//
//        if let userId = accessToken.userId {
//            let user = User(userId: userId)
//            user.login().then({
//                print("Logged In")
//                discoverVC.user = user
//                let test = "_id: \(user._id)\nuserId: \(user.userId)\nradius: \(user.radius)\n"
//                print(test)
//            })
//        } else {
//            print("\n\n Error userId not set \n\n")
//        }
//    }

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
                self.present(vc, animated: true, completion: nil)
                //self.performSegue(withIdentifier: "loginSegue", sender: nil)
            case .failed(let errors):
                print("failed because: " + errors.localizedDescription)
            default:
                print("cancelled")
            }
        }
    }
    
}

