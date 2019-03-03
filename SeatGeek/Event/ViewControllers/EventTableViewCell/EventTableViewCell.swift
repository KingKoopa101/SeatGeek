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
    
    func configure(with eventModel: EventViewModel){
        self.eventTitleLabel.text = eventModel.shortTitleDisplayString()
        self.eventDateLabel.text = eventModel.dateDisplayString()
        self.eventLocationLabel.text = eventModel.venueLocationDisplayString()
        if let imageURL = URL(string: eventModel.venueImageURLString()){
            self.eventImageView.kf.setImage(with: imageURL)
        }
        
        if (eventModel.isFavoriteEvent()){
            self.eventFavoriteIconImageView.image = UIImage(named: "Heart")
        }else{
            self.eventFavoriteIconImageView.image = nil
        }
    }
}
