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
    
    private let networkService: NetworkService
    private let favoriteEventService: FavoriteEventService
    
    //
    init(networkService: NetworkService,
         favoriteEventService: FavoriteEventService) {
        
        self.networkService = networkService
        self.favoriteEventService = favoriteEventService
    }
    
    // MARK: - Get Event
    
    func eventsForSearchTerm(_ searchTerm : String,
                             completion: @escaping (_ events : [EventViewModel], _ error : Error?) -> Void) {
        
        let urlComponents = networkService.baseURLComponents(path: .events,
                                                             searchTerm: searchTerm,
                                                             size: 25)
        print("Searching for: \(searchTerm)")
        
        self.requestEvents(for:urlComponents, completion: completion)
    }
    
    func latestEvents(completion: @escaping (_ events :[EventViewModel], _ error: Error?) -> Void) {
        print("🚀 Loading latest events")
        
        let urlComponents = networkService.baseURLComponents(path: .events, size: 50)
        
        self.requestEvents(for:urlComponents, completion: completion)
    }
    
    // MARK: - Update Event
    
    func updateEvent(_ model:EventViewModel){
        
        favoriteEventService.updateFavorite(eventId: model.eventId)
    }
    
    // MARK: - Request Event Helpers
    
    func requestEvents(for components: URLComponents, completion: @escaping (_ events :[EventViewModel], _ error: Error?) -> Void){
        
        guard let url = components.url else{
            //log
            print("🚨 Network Service Bad URLCompenents")
            completion([], nil)
            return
        }
        
        networkService.download(link: url,
                                completion: { [weak self] (data, error) in
                                    
                                    guard data != nil else {
                                        completion([], error)
                                        return
                                    }
                                    
                                    guard let strongSelf = self else {
                                        completion([], error)
                                        return
                                    }
                                    //Should seperate this out further.
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
}
