//
//  EventCardList.swift
//  VFlyer
//
//  Created by Brayden Streibel on 2017-03-28.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import UIKit
import CoreLocation

class EventCardList: UIView, DraggableViewDelegate {
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290
    
    private var cardsLoadedIndex = 0
    private var loadedCards = [EventCard]()
    private var allCards = [EventCard]()
    
    var user: User?
    //University lat 50.418034, long -104.590338
    var location: CLLocationCoordinate2D?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        super.layoutSubviews()
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)

//        xButton = UIButton(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2 + 35, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
//        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
//        xButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        checkButton = UIButton(frame: CGRectMake(self.frame.size.width/2 + CARD_WIDTH/2 - 85, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
//        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
//        checkButton.addTarget(self, action: "swipeRight", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        self.addSubview(xButton)
//        self.addSubview(checkButton)
    }
    
    private func createCard(_ event: Event) -> EventCard {
        let card = EventCard(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2,
                                           y: (self.frame.size.height - CARD_HEIGHT)/2,
                                           width: CARD_WIDTH,
                                           height: CARD_HEIGHT))
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
                insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
            } else {
                addSubview(loadedCards[i])
            }
            cardsLoadedIndex += 1
        }
    }
    
    func loadCards() {
        if let user = user, let location = location {
            user.discoverEvents(near: location).then({ events in
                self.createCards(events)
            })
        } else {
            print("User or location not set")
        }
    }
    
    private func removeCard() {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
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
    
    func swipeRight() {
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
    
    func swipeLeft() {
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
}
