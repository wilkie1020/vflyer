//
//  MyFlyersTableViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-14.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit

class MyFlyersTableViewController: UITableViewController {
    
    //MARK: Properties
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon: UIImage = #imageLiteral(resourceName: "listViewIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowAmount = self.user?.likedEvents.count {
            return rowAmount
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "myFlyersCell"
        
        //unwrap the returned optional using the guard. If it doesn't return something that can be unwrapped to a FlyerTableViewCell then a fatal error has occured.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FlyerTableViewCell else {
            fatalError("The dequeued cell is not an instance of FlyerTableViewCell.")
        }
        
        let event = self.user?.likedEvents[indexPath.row]
        
        // Configuring cell
        cell.label.text = event?.name
        cell.date.text = event?.endDate.description
        cell.location.text = "Not set yet"
        //cell.picture.image =

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: Actions
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SettingsViewController {
            self.user = sourceViewController.user
        } else if let sourceViewController = sender.source as? FlyerViewController {
            self.user = sourceViewController.user
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Sets navVC to be the destination of the segue which should be the Navigation controller of discover.
        guard let navVC = segue.destination as? UINavigationController else {
            fatalError("Unexpected destination: \(segue.destination)");
        }
        
        switch(segue.identifier ?? "") {
        case "listToView":
            guard let singleViewController = segue.destination as? FlyerViewController else {
                fatalError("Unexpected destination: \(segue.destination)");
            }
            singleViewController.user = self.user
        case "listToSettings":
            guard let settingsVC = navVC.viewControllers.first as? SettingsViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            settingsVC.user = self.user
        case "listToDiscover":
            guard let discoverVC = navVC.viewControllers.first as? DiscoverViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            discoverVC.user = self.user
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)");
        }

    }
}
