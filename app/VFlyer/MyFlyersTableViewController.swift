//
//  MyFlyersTableViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-14.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import FacebookCore

class MyFlyersTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Properties
    var user: User?
    var events = [Event]()
    var filteredEvents = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        
        if AccessToken.current == nil {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        if let user = user {
            user.login().then({
                let test = "_id: \(self.user?._id)\nuserId: \(self.user?.userId)\nradius: \(self.user?.radius)\n"
                print(test)
                user.loadLikedEvents().then({ events in
                    self.events = events
                    print("Liked events for user: \(events.count)")
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                })
            })
        }

        self.navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "listViewIcon"))
        
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredEvents.count
        }
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myFlyersCell", for: indexPath) as? FlyerTableViewCell else {
            fatalError("Something broke")
        }
        
        let event: Event
        if searchController.isActive && searchController.searchBar.text != "" {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        
        //Setting up the date as a string
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if (event.startDate != event.endDate)
        {
            dateString += dateFormatter.string(from: event.startDate)  + " - "
        }
        dateString += dateFormatter.string(from: event.endDate)
        
        cell.dateLabel.text = dateString
        cell.nameLabel.text = event.name
        cell.picture.image = event.image
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
    
    // MARK: Filtering
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredEvents = events.filter { event in
            return event.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
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
        
        
        switch(segue.identifier ?? "") {
        case "listToView":
            guard let detailVC = segue.destination as? FlyerViewController else {
                fatalError("Unexpected destination: \(segue.destination)");
            }
            if let indexPath = tableView.indexPathForSelectedRow {
                let event: Event
                if searchController.isActive && searchController.searchBar.text != "" {
                    detailVC.event = filteredEvents[indexPath.row]
                    detailVC.user = self.user
                    detailVC.bottomHidden = true
                    //detailVC.buttonsView.isHidden = true
                    //detailVC.scrollView.frame.size.height += detailVC.buttonsView.frame.size.height
                } else {
                    detailVC.event = self.events[indexPath.row]
                    detailVC.user = self.user
                    detailVC.bottomHidden = true
                    //detailVC.buttonsView.isHidden = true
                    //detailVC.scrollView.frame.size.height = detailVC.buttonsView.frame.size.height
                }
            }
//            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//            controller.event = candy
//            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
//            controller.navigationItem.leftItemsSupplementBackButton = true
        case "listToSettings":
            //Sets navVC to be the destination of the segue which should be the Navigation controller of discover.
            guard let navVC = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)");
            }
            guard let settingsVC = navVC.viewControllers.first as? SettingsViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            settingsVC.user = self.user
        case "listToDiscover":
            //Sets navVC to be the destination of the segue which should be the Navigation controller of discover.
            guard let navVC = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)");
            }
            guard let discoverVC = navVC.viewControllers.first as? DiscoverViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            discoverVC.user = self.user
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)");
        }

    }
}

extension MyFlyersTableViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
