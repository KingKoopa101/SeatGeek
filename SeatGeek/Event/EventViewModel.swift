//
//  File.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/2/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation

class EventViewModel {
    private let event : Event
    
    init(_ event:Event) {
        self.event = event
    }
    
    //Event
    
    func titleDisplayString () -> String {
        return event.title
    }
    
    func shortTitleDisplayString () -> String {
        return event.short_title
    }
    
    func dateDisplayString () -> String {
        
        guard event.date_tbd == false else{
            return "Event Time:TBD"
        }
        //yyyy-MM-dd'T'HH:mm:ss
        
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
        
        guard let date = isoDateFormatter.date(from:event.datetime_local) else{
                return "N/A"
        }
        
        return dateFormatter.string(from: date)
    }
    
    func selectedAsFavorite(_ selected : Bool){
        print("Event Favorited: \(event.title) :\(selected)")
    }
    
    
    //Venue
    
    func venueLocationDisplayString () -> String {
        
        if let city = self.event.venue?.city,
            let state = self.event.venue?.state{
            return "\(city), \(state)"
        }
        
        return ""
    }
    
    func venueImageURLString() -> String {
        if let venueURL = event.venue?.image {
            return venueURL
        }
        

        for performer in event.performers {
            if let performerURL = performer.image{
                return performerURL
            }
        }
        
        return "https://placebear.com/200/300"
    }
    
    //Venue
    
    func hasVenue() -> Bool {
        return (self.event.venue != nil)
    }
    
    func hasLocationString () -> Bool {
        return (hasVenue() &&
            self.event.venue?.city != nil &&
            self.event.venue?.state != nil)
    }
}
