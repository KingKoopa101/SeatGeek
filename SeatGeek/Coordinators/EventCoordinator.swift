//
//  EventCoordinator.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/1/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

class EventCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let eventService: EventService
    private var eventSearchViewController: EventSearchViewController?
    private var eventViewController: EventViewController?
    
    init(presenter: UINavigationController, eventService: EventService)
    {
        self.presenter = presenter
        self.eventService = eventService
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
                    
                    if let weakSelf = self,
                        let searchViewController = weakSelf.eventSearchViewController{
                        
                        if let realError = error {
                            searchViewController.presentAlert(withTitle: "Error",
                                                             message: realError.localizedDescription)
                        }
                        
                        searchViewController.events = events
                        searchViewController.tableView.reloadData()
                    }
                }
            })
        }
        
        let eventSearchViewController = EventSearchViewController(nibName: nil, bundle: nil)
        eventSearchViewController.title = "Events"
        eventSearchViewController.events = []
        eventSearchViewController.delegate = self
        
        presenter.pushViewController(eventSearchViewController, animated: true)
        
        self.eventSearchViewController = eventSearchViewController
    }
    
    
    func showEventDetailsViewController(_ model : EventViewModel,
                                        _ eventService : EventService)
    {
        print("👇 eventDetailsSelected")
        
        let eventViewController = EventViewController(nibName: "EventViewController", bundle: nil)
        eventViewController.eventViewModel = model
        eventViewController.delegate = self
        
        self.eventViewController = eventViewController
        
        //modally present event details
        let navigation = UINavigationController(rootViewController: eventViewController)
        presenter.present(navigation, animated: true, completion:nil)
    }
}

// MARK: - EventSearchViewControllerDelegate
extension EventCoordinator: EventSearchViewControllerDelegate {
    
    func eventUserSearchedForEvent(_ searchTerm: String) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            self?.eventService.eventsForSearchTerm(searchTerm, completion: {
                [weak self] (events, error) in
                DispatchQueue.main.async {
                    
                    if let weakSelf = self,
                        let eventSearchViewController = weakSelf.eventSearchViewController{
                        
                        if let realError = error {
                            eventSearchViewController.presentAlert(withTitle: "Error",
                                                             message: realError.localizedDescription)
                        }
                        
                        eventSearchViewController.filteredEvents = events
                        eventSearchViewController.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    func eventTableViewControllerDidSelectEvent(_ selectedEvent: EventViewModel) {
        showEventDetailsViewController(selectedEvent, eventService)
    }
}

// MARK: - EventViewModelFavoriteDelegate
extension EventCoordinator : EventViewControllerDelegate {
    func eventMarkedAsFavorite(_ selectedEvent: EventViewModel){
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
