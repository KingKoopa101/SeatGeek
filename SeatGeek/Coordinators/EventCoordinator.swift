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
    private var eventTableViewController: EventTableViewController? // 3
    private let eventService: EventService  // 4
    
    //    init(presenter: UINavigationController, kanjiStorage: KanjiStorage) {
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.eventService = EventService()
    }
    
    func start() {
        //        //temp while I put something in place to bring back last search.
        self.eventService.latestEvents( completion: {
            [weak self] events in
            
            if let weakSelf = self {
                weakSelf.allEvents = events
                weakSelf.eventTableViewController?.events = events
                weakSelf.eventTableViewController?.tableView.reloadData()
            }
            
        })
        
        // create init
        let eventTableViewController = EventSearchViewController(nibName: nil, bundle: nil) // 6
        eventTableViewController.title = "Events"
        eventTableViewController.events = allEvents
        eventTableViewController.delegate = self
        
        presenter.pushViewController(eventTableViewController, animated: true)  // 7
        
        self.eventTableViewController = eventTableViewController
    }
}


protocol EventTableViewControllerDelegate: class {
    //Returns Array of Events based on Search Term
    func eventUserSearchedForEvent(_ searchTerm: String, completion: @escaping (_ events :[EventViewModel]) -> Void)
    
    func eventTableViewControllerDidSelectEvent(_ selectedEvent: EventViewModel)
}

// MARK: - KanjiListViewControllerDelegate
extension EventTableCoordinator: EventTableViewControllerDelegate {
    
    func eventUserSearchedForEvent(_ searchTerm: String, completion: @escaping ([EventViewModel]) -> Void) {
        
        eventService.eventsForSearchTerm(searchTerm, completion: {
            [weak self] (events) in
            
            //need error here?
            completion(events)
        })
    }
    
    func eventTableViewControllerDidSelectEvent(_ selectedEvent: EventViewModel) {
        print("eventTableViewControllerDidSelectEvent")
        
        let eventViewController = EventViewController(nibName: "EventViewController", bundle: nil)
        eventViewController.eventViewModel = selectedEvent
        presenter.pushViewController(eventViewController, animated: true)
    }
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
