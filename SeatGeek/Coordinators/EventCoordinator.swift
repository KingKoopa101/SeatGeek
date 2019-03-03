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
    private let presenter: UINavigationController
    private var allEvents: [EventViewModel] = []
    private var eventSearchViewController: EventSearchViewController?
    private var eventViewController: EventViewController?
    private let eventService: EventService
    
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
           
            self?.eventService.latestEvents( completion: {
                [weak self] events, error in
                
                DispatchQueue.main.async {
                    
                    if let weakSelf = self {
                        weakSelf.allEvents = events
                        weakSelf.eventSearchViewController?.events = events
                        weakSelf.eventSearchViewController?.tableView.reloadData()
                    }
                }
            })
        }
        
        let eventSearchViewController = EventSearchViewController(nibName: nil, bundle: nil)
        eventSearchViewController.title = "Events"
        eventSearchViewController.events = allEvents
        eventSearchViewController.delegate = self
        
        presenter.pushViewController(eventSearchViewController, animated: true)
        
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
        self.eventViewController = eventViewController
        
        presenter.pushViewController(eventViewController, animated: true)
    }
}

// MARK: - EventSearchViewControllerDelegate
extension EventTableCoordinator: EventSearchViewControllerDelegate {
    
    func eventUserSearchedForEvent(_ searchTerm: String) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            self?.eventService.eventsForSearchTerm(searchTerm, completion: {
                [weak self] (events, error) in
                DispatchQueue.main.async {
//                    if (err)
                    
                    
                    if let weakSelf = self,
                        let eventViewController = weakSelf.eventSearchViewController{
                        eventViewController.filteredEvents = events
                        eventViewController.tableView.reloadData()
                    }
                }
                
                //need error here?
//                completion(events)
            })
        }
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

protocol EventSearchViewControllerDelegate: class {
    //Returns Array of Events based on Search Term
    func eventUserSearchedForEvent(_ searchTerm: String)
    
    func eventTableViewControllerDidSelectEvent(_ selectedEvent: EventViewModel)
}
