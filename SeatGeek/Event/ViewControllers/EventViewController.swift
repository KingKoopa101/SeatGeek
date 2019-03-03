//
//  EventViewController.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/2/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

class EventViewController : UIViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    //how can we initialize with this value
    var eventViewModel : EventViewModel?
    
    override func viewDidLoad() {
        self.title = eventViewModel?.titleDisplayString()
        
        eventLocationLabel.text = eventViewModel?.venueLocationDisplayString()
        eventDateLabel.text = eventViewModel?.dateDisplayString()
        
        if let imageURL = eventViewModel?.venueImageURLString(){
            eventImageView.download(from: imageURL)
        }
    }
    
//    private var event : Event
//
//    required init?(coder aDecoder: NSCoder) {
//        self.event = Event(name: "test")
//        super.init(coder: aDecoder)
//    }
//
//    convenience init(_ event:Event) {
//        self.event = event
////        super.init()
//    }
    
    //    convenience override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    convenience init() {
    //        self.init(nibName:nil, bundle:nil)
    //    }
}
