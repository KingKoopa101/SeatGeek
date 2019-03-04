//
//  Event.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 2/27/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation

struct ResponseData: Decodable {
//
//    var meta: Dictionary<<#Key: Hashable#>, Any>
//    var in_hand: Dictionary<<#Key: Hashable#>, Any>
    var events: [Event]
}

struct Event: Codable{
    
    var title: String
    var short_title: String
    var id: Int
    var datetime_local: String
    var date_tbd: Bool
    var venue: Venue?
    var performers: [Performer]
}

struct Venue: Codable{
    
    var name: String
    var city: String?
    var state: String?
    var image: String?
}

struct Performer: Codable{
    
    var name: String
//    var city: String?
//    var state: String?
    var image: String?
}
