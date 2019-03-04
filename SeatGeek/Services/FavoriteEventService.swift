//
//  FavoriteEventService.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/4/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation

class FavoriteEventService {
    private var allFavoritesFromCache: [String:String]
    
    init() {
        //need to load from cache.
        if let saved = UserDefaults.standard.value(forKey: "FavoriteEvents") as? [String: String]{
            allFavoritesFromCache = saved
        }else{
            allFavoritesFromCache = [:]
        }
    }
    
    func updateFavorite(eventId:Int){
        
        if (isFavorite(eventId: eventId)){
            allFavoritesFromCache.removeValue(forKey: String(eventId))
        }else{
            allFavoritesFromCache[String(eventId)] = ""
        }
        
        UserDefaults.standard.set(allFavoritesFromCache, forKey: "FavoriteEvents")
    }
    
    func isFavorite(eventId:Int) -> Bool {
        
        return (allFavoritesFromCache[String(eventId)] != nil)
    }
}
