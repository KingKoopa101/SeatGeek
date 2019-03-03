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
    let eventService: EventService //  1 EventService will provides asynch ev
    let window: UIWindow  // 2
    let rootViewController: UINavigationController  // 3
    let eventTableCoordinator: EventTableCoordinator
    
    init(window: UIWindow) { //4
        self.window = window
        eventService = EventService()
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        
        eventTableCoordinator = EventTableCoordinator(presenter: rootViewController)
                                                          //kanjiStorage: kanjiStorage)
    }
    
    func start() {  // 6
        window.rootViewController = rootViewController
        eventTableCoordinator.start()
        window.makeKeyAndVisible()
    }
}
