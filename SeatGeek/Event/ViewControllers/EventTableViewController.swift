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
