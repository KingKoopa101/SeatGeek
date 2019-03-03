//
//  EventTableViewController.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 2/27/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewController: UITableViewController {
    
    weak var delegate: EventTableViewControllerDelegate?
    var events : [EventViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.estimatedRowHeight = 80
        tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "EventTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        cell.textLabel?.text = events[indexPath.row].venueLocationDisplayString()
        
        return cell
    }
}

class EventSearchViewController: EventTableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredEvents = [EventViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
        let eventModel: EventViewModel = getEvent(for: indexPath)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath)
//
//        if (cell.isKind(of: EventTableViewCell.self)){
//            cell.configure*
//        }
//
//
//        return cell
//
        if let newCell : EventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as? EventTableViewCell
        {

            newCell.configure(with: eventModel)
            return newCell
        }

        let cell : UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        cell.textLabel?.text = eventModel.venueLocationDisplayString()

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
        
        if let searchString = searchController.searchBar.text {
            
            delegate?.eventUserSearchedForEvent(searchString, completion: {
                [weak self] events in
                
                if let weakSelf = self {
                    weakSelf.filteredEvents = events
                    weakSelf.tableView.reloadData()
                }
            })
        }
    }
}

extension UIImageView {
    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        contentMode = mode
        self.image = nil
        
        NetworkService().download(link: link, completion: {
            data ,error in
            
            guard data != nil else{
                //bad data
                return
            }
            print("uiimageview: "+link)
            
            if let image = UIImage(data: data!){
                DispatchQueue.main.async() { [weak self] in
                    
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        })
    }
}
