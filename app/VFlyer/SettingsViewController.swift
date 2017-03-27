//
//  SettingsViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-13.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class SettingsViewController: UITableViewController {
    
    
    //MARK: Properties
    let kmFactor = 1000
    var sliderActual: Int = 5000
    var user: User?
    
    //Outlets
    @IBOutlet weak var snapSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    //Bar button
    @IBOutlet weak var backButton: UIBarButtonItem!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let icon: UIImage = #imageLiteral(resourceName: "settingsIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
        
        guard let user = user else {
            fatalError("User not logged in")
        }
        
        distanceLabel.text = "\((user.radius)!/1000)km."
        switch (user.radius!) {
        case 1000:
            snapSlider.value = 1
        case 5000:
            snapSlider.value = 2
        case 10000:
            snapSlider.value = 3
        case 25000:
            snapSlider.value = 4
        case 50000:
            snapSlider.value = 5
        default:
            snapSlider.value = 6
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func snapSliderChanged(_ sender: UISlider) {
        let value = sender.value.rounded()
        sender.value = value
        
        switch (Int(value)) {
        case 1:
            user?.radius = 1000
        case 2:
            user?.radius = 5000
        case 3:
            user?.radius = 10000
        case 4:
            user?.radius = 25000
        case 5:
            user?.radius = 50000
        default:
            user?.radius = 100000
        }
        
        distanceLabel.text = "\((user?.radius)!/1000)km."
        
    }
    
    //MARK: Actions
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        user?.save().then({ _ in
            self.dismiss(animated: true, completion: nil)
        })
    }

    @IBAction func logOutTriggered(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { action in
            let loginManager = LoginManager()
            loginManager.logOut()
            self.redirectToLogin()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }

        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }

    @IBAction func deleteAccountTriggered(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive) { action in
            guard let user = self.user else {
                fatalError("User not logged in")
            }
            
            user.delete().then { result in
                if (result) {
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    self.redirectToLogin()
                }
                }.catch { error in
                    print(error.localizedDescription)
            }

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
    }
    
    private func redirectToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    

}
