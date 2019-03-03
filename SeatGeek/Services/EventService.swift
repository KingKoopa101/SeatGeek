//
//  EventService.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 2/28/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation

struct EventFavoritesCache {
    let eventArray: [String]
    let eventDictionary: [String: String]
}

// Provides events from Network Service
class EventService {
    
    private let allFavoritesFromCache: [String:String]
    private var events : [Event] = []
    private let baseURL : String = "https://api.seatgeek.com/2/events?client_id=MTU1NDY5MTZ8MTU1MTQwMzUwMy4xMQ"
    
    //
    init() {
        //need to load from cache.
        allFavoritesFromCache = [:]
    }
    
    func eventsForSearchTerm(_ searchTerm : String,
                             completion: @escaping (_ events :[EventViewModel], _ error: Error?) -> Void) {
        
        var newURL : String = baseURL
        newURL = newURL + "&q=\(searchTerm)"
        
        print("Searching for: \(searchTerm)")
        
        self.requestEvents(for: newURL, completion: completion)
    }
    
    func latestEvents(completion: @escaping (_ events :[EventViewModel], _ error: Error?) -> Void) {
        
        var newURL : String = baseURL
        newURL = newURL + "&per_page=100"
        
        print("🚀 Loading initial events")
        
        self.requestEvents(for: newURL, completion: completion)
    }
    
    func requestEvents(for URLString: String, completion: @escaping (_ events :[EventViewModel], _ error: Error?) -> Void){
        
        guard let url = URL(string: URLString) else{
            //log
            print("🚨 Network Service Bad URL: \(link)")
            completion([], nil)
            return
        }
        
        NetworkService().download(link: url,
                                  completion: { [weak self] (data, error) in
                                    
                                    if self == nil{
                                        return
                                    }
                                    
                                    do {
                                        let decoder = JSONDecoder()
                                        let jsonData = try decoder.decode(ResponseData.self, from: data!)
                                        
                                        DispatchQueue.main.async { [weak self] in
                                            
                                            self?.events = jsonData.events
                                            var tempArray: [EventViewModel] = []
                                            for event in jsonData.events{
                                                tempArray.append(EventViewModel(event))
                                            }
                                            
                                            completion(tempArray, nil)
                                        }
                                    } catch {
                                        completion([], error)
                                        print("🚨 NetworkService error:\(error)")
                                    }
        })
    }
}
