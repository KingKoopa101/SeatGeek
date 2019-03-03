//
//  EventService.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 2/28/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation

// Provides events from Network Service
class EventService {
    
    private var allFavoritesFromCache: [String:String]
    private var events : [Event] = []
    private var eventViewModels : [EventViewModel] = []
    private let baseURL : String = "https://api.seatgeek.com/2/events?client_id=MTU1NDY5MTZ8MTU1MTQwMzUwMy4xMQ"
    
    //
    init() {
        //need to load from cache.
        if let saved = UserDefaults.standard.value(forKey: "FavoriteEvents") as? [String: String]{
            allFavoritesFromCache = saved
        }else{
            allFavoritesFromCache = [:]
        }
    }
    
    // MARK: - Get Event
    
    func eventsForSearchTerm(_ searchTerm : String,
                             completion: @escaping (_ events :[EventViewModel], _ error: Error?) -> Void) {
        
        let encodedSearchTerm = self.encodeSearchTerm(searchTerm)
        let searchURL = baseURL + "&q=" + encodedSearchTerm
        
        print("Searching for: \(searchTerm)")
        
        self.requestEvents(for: searchURL, completion: completion)
    }
    
    func latestEvents(completion: @escaping (_ events :[EventViewModel], _ error: Error?) -> Void) {
        
        let latestEventURL = baseURL + "&per_page=100"
        
        print("🚀 Loading initial events")
        
        self.requestEvents(for: latestEventURL, completion: completion)
    }
    
    // MARK: - Update Event
    
    func updateEvent(_ model:EventViewModel){
        
        let id = String(model.eventId)
        
        //this needs updating
        if (model.isFavoriteEvent()){
            allFavoritesFromCache[id] = ""
        }else{
            allFavoritesFromCache.removeValue(forKey: id)
        }
        
        UserDefaults.standard.set(allFavoritesFromCache, forKey: "FavoriteEvents")
    }
    
    // MARK: - Request Event Helpers
    
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
                                                let newModel : EventViewModel
                                                
                                                if (self?.allFavoritesFromCache[String(event.id)] != nil){
                                                    newModel = EventViewModel(event, true)
                                                }else{
                                                    newModel = EventViewModel(event, false)
                                                }
                                                
                                                tempArray.append(newModel)
                                            }
                                            
                                            self?.eventViewModels = tempArray
                                            
                                            completion(tempArray, nil)
                                        }
                                    } catch {
                                        completion([], error)
                                        print("🚨 NetworkService error:\(error)")
                                    }
        })
    }
    
    func encodeSearchTerm(_ searchTerm : String) -> String {
        return searchTerm.replacingOccurrences(of: " ", with: "+")
    }
}
