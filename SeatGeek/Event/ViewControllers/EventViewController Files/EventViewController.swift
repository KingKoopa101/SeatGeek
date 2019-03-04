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
    weak var delegate: EventViewControllerDelegate?
    
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
        
        setupButton()
    }
    
    func setupButton () {
        let favoriteButton : UIBarButtonItem
        
        if(eventViewModel?.isFavoriteEvent() ?? false){
            favoriteButton = UIBarButtonItem(image: UIImage(named: "Heart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(action(_:)))
        }else{
            favoriteButton = UIBarButtonItem(image: UIImage(named: "EmptyHeart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(action(_:)))
        }
        
        
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func setupDataFromEvent() {

        eventLocationLabel.text = eventViewModel?.venueLocationDisplayString()
        eventDateLabel.text = eventViewModel?.dateDisplayString()
        
        if let imageURL = eventViewModel?.venueImageURLString(){
            self.eventImageView.loadImage(with: imageURL, isPlaceholder: false)
        }else{
            self.eventImageView.loadImage(with: URLs.placeholderURL, isPlaceholder: true)
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        if let isFavorite = eventViewModel?.isFavoriteEvent(){
            sender.isSelected = isFavorite
            
            //WIP
            eventViewModel?.selectedAsFavorite(!isFavorite)
            self.delegate?.eventMarkedAsFavorite(eventViewModel!)
            
            setupButton()
        }
    }
}
