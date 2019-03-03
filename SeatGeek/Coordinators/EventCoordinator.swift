//
//  EventCoordinator.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/1/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

class EventTableCoordinator: Coordinator {
    private let presenter: UINavigationController  // 1
    private var allEvents: [EventViewModel] = [] // 2
    private var eventSearchViewController: EventSearchViewController? // 3
    private let eventService: EventService  // 4
    
    init(presenter: UINavigationController)
    {
        self.presenter = presenter
        self.eventService = EventService()
    }
    
    func start()
    {
        //promise?
        showEventSearchViewController(with: eventService)
    }
    
    func showEventSearchViewController(with eventService : EventService)
    {
        //temp while I put something in place to bring back last search.
        self.eventService.latestEvents( completion: {
            [weak self] events, error in
            
            if let weakSelf = self {
                weakSelf.allEvents = events
                weakSelf.eventSearchViewController?.events = events
                weakSelf.eventSearchViewController?.tableView.reloadData()
            }
        })
        
        let eventSearchViewController = EventSearchViewController(nibName: nil, bundle: nil) // 6
        eventSearchViewController.title = "Events"
        eventSearchViewController.events = allEvents
        eventSearchViewController.delegate = self
        
        presenter.pushViewController(eventSearchViewController, animated: true)  // 7
        
        self.eventSearchViewController = eventSearchViewController
    }
    
    
    func showEventDetailsViewController(_ model : EventViewModel,
                                        _ eventService : EventService)
    {
        print("eventTableViewControllerDidSelectEvent")
        
        let eventViewController = EventViewController(nibName: "EventViewController", bundle: nil)
        eventViewController.eventViewModel = model
        eventViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        eventViewController.delegate = self
        presenter.pushViewController(eventViewController, animated: true)
    }
}

// MARK: - EventSearchViewControllerDelegate
extension EventTableCoordinator: EventSearchViewControllerDelegate {
    
    func eventUserSearchedForEvent(_ searchTerm: String, completion: @escaping ([EventViewModel]) -> Void) {
        
        eventService.eventsForSearchTerm(searchTerm, completion: {
            [weak self] (events, error) in
            
            //need error here?
            completion(events)
        })
    }
    
    func eventTableViewControllerDidSelectEvent(_ selectedEvent: EventViewModel) {
        showEventDetailsViewController(selectedEvent, eventService)
    }
}

// MARK: - EventViewModelFavoriteDelegate
extension EventTableCoordinator : EventViewControllerDelegate {
    func eventMarkedAsFavorite(_ selectedEvent: EventViewModel){
        print("test")
        eventService.updateEvent(selectedEvent)
        eventSearchViewController?.tableView.reloadData()
    }
}




protocol EventViewControllerDelegate: class {
    func eventMarkedAsFavorite(_ selectedEvent: EventViewModel)
}

protocol EventTableViewControllerDelegate: class {
    
}


protocol EventSearchViewControllerDelegate: class {
    //Returns Array of Events based on Search Term
    func eventUserSearchedForEvent(_ searchTerm: String, completion: @escaping (_ events :[EventViewModel]) -> Void)
    
    func eventTableViewControllerDidSelectEvent(_ selectedEvent: EventViewModel)
}


//protocol Gettable {
//    associatedtype Data
//
//    func get(completionHandler: Result<Data> -> Void)
//}
//
//struct FoodService {
//
//    func get(completionHandler: Result<[Event]> -> Void) {
//        // make asynchronous API call
//        // and return appropriate result
//    }
//}
