//
//  EventSearchViewController.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/3/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

class EventSearchViewController: EventTableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    weak var delegate: EventSearchViewControllerDelegate?
    var filteredEvents = [EventViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    // MARK: - Private Helpers instance methods
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func getEvent(for indexPath:IndexPath) -> EventViewModel {
        let event: EventViewModel
        if isFiltering() {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        return event
    }
    
    // Mark: UITableView Delegates & Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredEvents.count
        }
        
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath)
        
        if let eventCell : EventTableViewCell = cell as? EventTableViewCell
        {
            eventCell.configure(with: getEvent(for: indexPath))
            return eventCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent: EventViewModel = getEvent(for: indexPath)
        delegate?.eventTableViewControllerDidSelectEvent(selectedEvent)
    }
}

extension EventSearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        guard delegate != nil else {
            //fail
            return
        }
        
        guard let searchString = searchController.searchBar.text else {
            //no search string
            return
        }
        
//        if searchString == ""{
//            //First time tapped.
//            return
//        }
        
        delegate?.eventUserSearchedForEvent(searchString)
    }
}
