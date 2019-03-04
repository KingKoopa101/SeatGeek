//
//  EventTableViewCell.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/2/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class EventTableViewCell : UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventFavoriteIconImageView: UIImageView!
    
    func configure(with eventViewModel: EventViewModel){
        self.eventTitleLabel.text = eventViewModel.shortTitleDisplayString()
        self.eventDateLabel.text = eventViewModel.dateDisplayString()
        self.eventLocationLabel.text = eventViewModel.venueLocationDisplayString()
        
        if let imageURL = eventViewModel.venueImageURLString(){
            self.eventImageView.loadImage(with: imageURL, isPlaceholder: false)
        }else{
            self.eventImageView.loadImage(with: URLs.placeholderURL, isPlaceholder: true)
        }
        
        if (eventViewModel.isFavoriteEvent()){
            self.eventFavoriteIconImageView.image = UIImage(named: "Heart")
        }else{
            self.eventFavoriteIconImageView.image = nil
        }
    }
}
