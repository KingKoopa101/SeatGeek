//
//  NetworkService.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/3/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation

/*
Punted on this class to complete more of the other work downstream.
This could be replaced with a more thorough solution such as AFNetworking.
Also, could use some libraries more adapted to the SeatGeek API
*/
class NetworkService {
    func download (link: URL, completion: @escaping (_ data :Data?, _ error :Error?) -> Void){
        
        URLSession.shared.dataTask(with: link){
            (data, response, error) in
            
            guard error == nil else{
                
                completion(nil, error)
                return
            }
            
            completion(data!, nil)
            }.resume()
    }
}

struct URLs {
    
    private  struct Routes {
        static let event = "events"
        static let venue = "venues"
        static let performer = "performer"
    }
    
    static let Client_id = "client_id=MTU1NDY5MTZ8MTU1MTQwMzUwMy4xMQ"
    static let SeatGeekURL = "https://api.seatgeek.com/2/"
    static let placeholderURL = "https://placebear.com"
    
    private static let EventsRoute = SeatGeekURL + Routes.event
    
    static var EventBaseUrl: String {
        return EventsRoute + "?" + Client_id
    }
}
