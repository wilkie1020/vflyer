//
//  SettingsViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-13.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    //MARK: Properties
    let kmFactor = 1000
    var sliderActual: Int = 5000
    var user: User?
    //Outlets
    @IBOutlet weak var snapSlider: SnapSlider!
    @IBOutlet weak var testLabel: UILabel!
    
    //Bar button
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let icon: UIImage = #imageLiteral(resourceName: "settingsIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
        snapSlider.value = 20
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func snapSliderChanged(_ sender: SnapSlider)
    {
        let temp = snapSlider.snap()
        snapSlider.value = snapSlider.snap()
        if(temp == 1)
        {
            sliderActual = 1 * kmFactor
        }
        else if(temp == 20)
        {
            sliderActual = 5 * kmFactor
        }
        else if(temp == 40)
        {
            sliderActual = 10 * kmFactor
        }
        else if(temp == 60)
        {
            sliderActual = 25 * kmFactor
        }
        else if(temp == 80)
        {
            sliderActual = 50 * kmFactor
        }
        else if(temp == 100)
        {
            sliderActual = 100 * kmFactor
        }
        
        testLabel.text = String(sliderActual) + " meters"
        //user?.radius = sliderActual
        
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
