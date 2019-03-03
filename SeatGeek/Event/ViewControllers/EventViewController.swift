//
//  EventViewController.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/2/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class EventViewController : UIViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    //how can we initialize with this value
    var eventViewModel : EventViewModel?
    
    override func viewDidLoad() {
        
        setupUI()
        
        setupDataFromEvent()
    }
    
    func setupUI() {
        
        //GO further.
        let myView = Bundle.loadView(fromNib: "EventViewControllerCustomTitleView", withType: EventViewControllerCustomTitleView.self)
        myView.eventTitleLabel.text = eventViewModel?.titleDisplayString()
        myView.frame.size = CGSize(width: 100, height: 300)
        
        self.navigationItem.titleView = myView
        
        let favoriteButton = UIBarButtonItem(image: UIImage(named: "EmptyHeart"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(action(_:)))
        
        navigationItem.rightBarButtonItem = favoriteButton
        
        
    }
    
    func setupDataFromEvent() {

        eventLocationLabel.text = eventViewModel?.venueLocationDisplayString()
        eventDateLabel.text = eventViewModel?.dateDisplayString()
        
        //placeholder for error needed.
        if let imageURLString = eventViewModel?.venueImageURLString(),
            let imageURL = URL(string: imageURLString){
            self.eventImageView.kf.setImage(with: imageURL)
        }
    }
    
    @IBAction func action(_ sender: AnyObject) {
//        print("CustomRightViewController IBAction invoked!")
        eventViewModel?.selectedAsFavorite(true)
    }
}
