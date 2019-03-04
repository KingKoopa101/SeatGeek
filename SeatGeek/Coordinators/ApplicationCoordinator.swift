//
//  ApplicationCoordinator.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 2/27/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    let eventService: EventService
    let window: UIWindow
    let rootViewController: UINavigationController
    let eventTableCoordinator: EventCoordinator
    
    init(window: UIWindow) {
        self.window = window
        eventService = EventService(networkService: NetworkService(),
                                    favoriteEventService: FavoriteEventService())
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.largeTitleDisplayMode = .always
        
        eventTableCoordinator = EventCoordinator(presenter: rootViewController,
                                                 eventService: eventService)
    }
    
    func start() {
        window.rootViewController = rootViewController
        eventTableCoordinator.start()
        window.makeKeyAndVisible()
    }
}
