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
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func viewDidLoad() {
        setupDataFromEvent()
    }
    
    func setupUI() {
        
        //GO further.
        let myView = Bundle.loadView(fromNib: "EventViewControllerCustomTitleView", withType: EventViewControllerCustomTitleView.self)
        myView.eventTitleLabel.text = eventViewModel?.titleDisplayString()
        
        self.navigationItem.titleView = myView
        self.navigationItem.prompt = " "
        
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
    
    @IBAction func action(_ sender: UIBarButtonItem) {
        if let isFavorite = eventViewModel?.isFavoriteEvent(){
            
            eventViewModel?.selectedAsFavorite(!isFavorite)
            self.delegate?.eventMarkedAsFavorite(eventViewModel!)
            
            setupButton()
        }
    }
}
