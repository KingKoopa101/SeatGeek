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
    
    private let baseURL : String = URLs.EventBaseUrl
    private let favoriteEventService: FavoriteEventService
    
    //
    init(favoriteEventService: FavoriteEventService) {
        
        self.favoriteEventService = favoriteEventService
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
        
        favoriteEventService.updateFavorite(eventId: model.eventId)
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
                                    
                                    guard data != nil else {
                                        completion([], error)
                                        return
                                    }
                                    
                                    guard let strongSelf = self else {
                                        completion([], error)
                                        return
                                    }
                                    
                                    do {
                                        let decoder = JSONDecoder()
                                        let jsonData = try decoder.decode(ResponseData.self, from: data!)
                                        
                                        var tempArray: [EventViewModel] = []
                                        for event in jsonData.events{
                                            let newModel : EventViewModel
                                            
                                            let isFavorite = strongSelf.favoriteEventService.isFavorite(eventId:event.id)
                                            newModel = EventViewModel(event: event,
                                                                      isFavorite: isFavorite)
                                            
                                            tempArray.append(newModel)
                                        }
                                        completion(tempArray, nil)
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
