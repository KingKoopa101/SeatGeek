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
    private var isFavorite : Bool
    
    //Pull these out?
    private lazy var isoDateFormatter : DateFormatter = {
        let isoDateFormatterLazy = DateFormatter()
        isoDateFormatterLazy.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return isoDateFormatterLazy
    }()
    
    private lazy var dateFormatter : DateFormatter = {
        let dateFormatterLazy = DateFormatter()
        dateFormatterLazy.dateFormat = "E, d MMM yyyy HH:mm a"
        return dateFormatterLazy
    }()
    
    var eventId : Int {
        return event.id
    }
    
    init(event : Event,
         isFavorite : Bool) {
        self.event = event
        self.isFavorite = isFavorite
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
            return "Event Date: TBD"
        }
        
        guard event.time_tbd == false else{
            return "Event Time: TBD"
        }
        
        guard let date = isoDateFormatter.date(from:event.datetime_local) else{
                return "N/A"
        }
        
        return dateFormatter.string(from: date)
    }
    
    //Could be better.
    func selectedAsFavorite(_ selected : Bool){
        isFavorite = selected
        print("👍 Event Favorited: \(event.title) :\(selected)")
    }
    
    func isFavoriteEvent() -> Bool{
        return isFavorite
    }
    
    //Venue
    
    func venueLocationDisplayString () -> String {
        
        if let venue = self.event.venue,
            let city = venue.city,
            let state = venue.state{
            return "\(city), \(state)"
        }
        
        return "No Location"
    }
    
    private func venueImageURLString() -> String? {
        
        guard let venue = event.venue else{
            return nil
        }
        
        if let venueURL = venue.image {
            return venueURL
        }

        for performer in event.performers {
            if let performerURL = performer.image{
                return performerURL
            }
        }
        
        return nil
    }
    
    func venueImageURLStringTuple() -> (imageUrl : String, needsSize : Bool) {
        
        if let imageURL = self.venueImageURLString(){
            return (imageURL, false)
        }else{
            return (URLs.placeholderURL, true)
        }
    }
}
