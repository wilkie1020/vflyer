//
//  DiscoverViewController.swift
//  VFlyer
//
//  Created by Mat Wilkie on 2017-03-14.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookCore

class DiscoverViewController: UIViewController, LocationControllerDelegate, DraggableViewDelegate {
    
    //MARK: Properties
    var user: User?
    var locationController = LocationController()
    var lastUpdate: Date?
    
    fileprivate let MAX_BUFFER_SIZE = 2
//    fileprivate let CARD_HEIGHT: CGFloat = 366
//    fileprivate let CARD_WIDTH: CGFloat = 275
    fileprivate let CARD_HEIGHT: CGFloat = 400
    fileprivate let CARD_WIDTH: CGFloat = 300

    
    fileprivate var cardsLoadedIndex = 0
    fileprivate var loadedCards = [EventCard]()
    fileprivate var allCards = [EventCard]()
    
    // MARK: Outlets
    @IBOutlet weak var eventCardList: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon: UIImage = #imageLiteral(resourceName: "discoverIcon")
        let iconImage = UIImageView(image:icon)
        self.navigationItem.titleView = iconImage
        
        locationController.delegate = self
        
        noButton.layer.cornerRadius = 40
        yesButton.layer.cornerRadius = 40
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !locationController.service() {
            //pop up option to enable gps
            let alert = UIAlertController(title: "GPS Unavailable", message: "GPS Unavailable, enable GPS?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { action in
                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                    UIApplication.shared.openURL(settingsURL as URL)
                }
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true)
        }
        
        if AccessToken.current == nil {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        locationController.start()
        activityIndicator.startAnimating()
        if let accessToken = AccessToken.current, let userId = accessToken.userId {
            user = User(userId: userId)
            user?.login().then({
                print("Logged in")
                //University lat 50.418034, long -104.590338
                let location = CLLocationCoordinate2D(latitude: 50.418034, longitude: -104.590338)
                self.loadCards(near: location)
            })
        } else {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Sets navVC to be the destination of the segue which should be the Navigation controller
        
        switch (segue.identifier ?? ""){
        case "discoverToDetail":
            guard let detailVC = segue.destination as? FlyerViewController else {
                fatalError("Unexpected destination: \(segue.destination)");
            }
            //sets the user for page
            detailVC.user = self.user
            locationController.stop()
            detailVC.bottomHidden = false
            detailVC.checkBoxHidden = true
            detailVC.event = loadedCards[0].event
        

        case "discoverToList":
            guard let navVC = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)");
            }
            //Sets discoverVC to be the first viewController on the navigation stack. This should be the Disocver view.
            //If unable to set this a fatal error occured.
            guard let discoverVC = navVC.viewControllers.first as? MyFlyersTableViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            //sets the user at the discover page before seguingfatalError("Unexpected destination: \(navVC.viewControllers.first)");
            discoverVC.user = self.user
            locationController.stop()
        case "discoverToSettings":
            guard let navVC = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)");
            }
            //Sets discoverVC to be the first viewController on the navigation stack. This should be the Disocver view.
            //If unable to set this a fatal error occured.
            guard let settingsVC = navVC.viewControllers.first as? SettingsViewController else {
                fatalError("Unexpected destination: \(navVC.viewControllers.first)");
            }
            //sets the user at the discover page before seguingfatalError("Unexpected destination: \(navVC.viewControllers.first)");
            settingsVC.user = self.user
            locationController.stop()
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)");
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func unwindToDiscover(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SettingsViewController {
            self.user = sourceViewController.user
        } else if let sourceViewController = sender.source as? FlyerViewController {
            self.user = sourceViewController.user
        }
    }
    
    
    @IBAction func listButtonPressed(_ sender: UIBarButtonItem) {
        user?.loadLikedEvents().then({_ in
            self.performSegue(withIdentifier: "discoverToList", sender: nil)
        })
    }
    
    @IBAction func noButtonTriggered(_ sender: UIButton) {
        if loadedCards.count <= 0 {
            return
        }
        let card: EventCard = loadedCards[0]
        card.overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            card.overlayView.alpha = 1
        })
        card.leftClickAction()
    }
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform.identity
            }
        })
    }
    
    @IBAction func yesButtonTriggered(_ sender: UIButton) {
        if loadedCards.count <= 0 {
            return
        }
        let card: EventCard = loadedCards[0]
        card.overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            card.overlayView.alpha = 1
        })
        card.rightClickAction()
    }
    
    // MARK: - LocationControllerDelegate
    
    var test = 0
    
    func locationDidUpdate(location: CLLocation?) {
        //see if array is empty and ensure update hase not occured recently
    }
    
    
    
    // MARK: - DraggableViewDelegate
    
    private func createCard(_ event: Event) -> EventCard {
        
        let x = (eventCardList.frame.size.width - CARD_WIDTH) / 2
        let y = (eventCardList.frame.size.height - CARD_HEIGHT) / 2
        
        let card = EventCard(frame: CGRect(x: x, y: y, width: CARD_WIDTH, height: CARD_HEIGHT))
        card.event = event
        card.delegate = self
        return card
    }
    
    private func createCards(_ events:[Event]) {
        print("Discovered events for user: \(events.count)")
        
        let numLoadedCardsCap = events.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : events.count
        
        for event in events {
            let newCard: EventCard = createCard(event)
            allCards.append(newCard)
            if loadedCards.count < numLoadedCardsCap {
                loadedCards.append(newCard)
            }
        }
        
        for i in 0 ..< loadedCards.count {
            if i > 0 {
                eventCardList.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
            } else {
                eventCardList.addSubview(loadedCards[i])
            }
            cardsLoadedIndex += 1
        }
    }
    
    func loadCards(near location:CLLocationCoordinate2D) {
        guard let user = user else {
            fatalError("Something broke")
        }
        
        if user.isLoggedIn {
            lastUpdate = Date()
            activityIndicator.startAnimating()
            user.discoverEvents(near: location).then({ events in
                self.createCards(events)
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    private func removeCard() {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            eventCardList.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func cardSwipedLeft(card: UIView) {
        print("Swiped Left")
        
        guard let user = user else {
            fatalError("User not set")
        }
        
        let event = loadedCards[0].event
        event.passEvent(forUser: user).then { result in
            if result {
                self.removeCard()
            }
        }
    }
    
    func cardSwipedRight(card: UIView) {
        print("Swiped Right")
        
        guard let user = user else {
            fatalError("User not set")
        }
        
        let event = loadedCards[0].event
        event.likeEvent(forUser: user).then { result in
            if result {
                self.removeCard()
            }
        }
    }
}
