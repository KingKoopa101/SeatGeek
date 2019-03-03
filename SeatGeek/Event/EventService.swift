//
//  EventService.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 2/28/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation

//struct KanjiCache {
//    let kanjiArray: [Kanji]
//    let kanjiDictionary: [String: Kanji]
//}

// Provides kanji data from JSON
class EventService {
//    static let kanjiURL = Bundle.main.url(forResource: "knji", withExtension: "json")!
//    private let allKanjiFromJSON: KanjiCache
    
    private var events : [Event] = []
    private let URL : String = "https://api.seatgeek.com/2/events?client_id=MTU1NDY5MTZ8MTU1MTQwMzUwMy4xMQ"
    
//
    init() {
        // Parse json and store it's data
//        let data = try! Data(contentsOf: KanjiStorage.kanjiURL)
//        let allKanjis = try! JSONDecoder().decode([Kanji].self, from: data)
//
//        let kanjiDictionary = allKanjis.reduce([:]) { (dictionary, kanji) -> [String: Kanji] in
//            var dictionary = dictionary
//            dictionary[kanji.character] = kanji
//            return dictionary
//        }
//
//        // Save new cache
//        allKanjiFromJSON = KanjiCache(kanjiArray: allKanjis, kanjiDictionary: kanjiDictionary)
    }
    
//    func allKanji() -> [Kanji] {
//        return allKanjiFromJSON.kanjiArray
//    }
    
//    func kanjiForWord(_ word: String) -> [Kanji] {
//        let kanjiInWord: [Kanji] = word.compactMap { (character) -> Kanji? in
//            let kanjiForCharacter = allKanjiFromJSON.kanjiDictionary["\(character)"]
//            return kanjiForCharacter
//        }
//        return kanjiInWord
//    }
    
    func eventsForSearchTerm(_ searchTerm : String, completion: @escaping (_ events :[EventViewModel]) -> Void) {
        
        var newURL : String = URL
        newURL = newURL + "&q=\(searchTerm)"
        
        print("Searching for: \(searchTerm)")
        
        //Should this be done.
        NetworkService().download(link: newURL,
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
                                            
                                           completion(tempArray)
                                        }
                                    } catch {
                                        print("error:\(error)")
                                    }
        })
    }
    
    
    
    func latestEvents(completion: @escaping (_ events :[EventViewModel]) -> Void) {
        
        var newURL : String = URL
        newURL = newURL + "&per_page=100"
        
        NetworkService().download(link: newURL,
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
                                            
                                            completion(tempArray)
                                        }
                                    } catch {
                                        print("error:\(error)")
                                    }
        })
        
//        NetworkService().download(link: newURL,
//                                  completion: { [weak self] (data) in
//
//                                    if self == nil{
//                                        return
//                                    }
//                                    do{
//                                        let data = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                                        if let resultDictionary : Dictionary = data as? [String:Any],
//                                            let eventsArray : Array = resultDictionary["events"] as? [[String:Any]]{
//
//                                            var tempArray: [Event] = []
//                                            for entry in eventsArray {
//                                                if let title : String = entry["title"] as? String
//                                                {
//                                                    let event = Event(title:title)
//                                                    tempArray.append(event)
//                                                }
//                                            }
//
//                                            print("")
//                                            DispatchQueue.main.async {
//                                                self?.events = tempArray
//                                                completion(tempArray)
//                                                //return eventsArray
//                                                //                            tempArray
//                                                print("")
//                                            }
//                                        }
//                                    }catch{
//
//                                    }
//        })
    }
}

class NetworkService {
    func download (link: String, completion: @escaping (_ data :Data?, _ error :Error?) -> Void){
        
        guard let url = URL(string: link) else{
            //log
            print("Network Service :bad URL: \(link)")
            completion(nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            
            guard error == nil else{
                //                completion(nil)?
                completion(nil, error)
                return
            }
            
            completion(data!, nil)
            }.resume()
    }
}


