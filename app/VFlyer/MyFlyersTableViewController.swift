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
        
        //checks if the user has an ID to query the api with. If not an error has occured. Otherwise query the database for all liked events.
        if let _id = user?._id {
            let endpoint = "http://159.203.7.42:8000/api/users/" + _id + "/liked"
            let url = URL(string: endpoint)!
            let request = URLRequest(url: url)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let error = error {
                    // The error should bhe extracted from it's JSON dictionary and presented to the user.
                    print ("Problems upstream. Following errors occured: " + error.localizedDescription)
                } else if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let response = json as? [[String: Any]] {
                        for item in response {
                            if let event = Event(json: item) {
                                self.events.append(event)
                            }
                        }
                    }
                }
            })
            task.resume()
        } else {
            print("Error no user ID could not get list of Events")
        }
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
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FlyerTableViewCell"
        
        //unwrap the returned optional using the guard. If it doesn't return something that can be unwrapped to a MealTableViewCell then a fatal error has occured.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FlyerTableViewCell else {
            fatalError("The dequeued cell is not an instance of FlyerTableViewCell.")
        }
        
        let event = self.events[indexPath.row] //set the variable meal to the object in the meals array at the current row index.
        
        // Configuring cell
        cell.label.text = event.name
        cell.date.text = event.endDate.description
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "listToView":
            print("segue to view")
        case "listToSettings":
            print("segue to settings")
        case "listToDiscover":
            print("segue to Discover")
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)");
        }

    }
}
