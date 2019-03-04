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

struct URLs {
    static let scheme = "https"
    static let host = "api.seatgeek.com"
    static let eventPath = "events"
    static let api_key = "MTU1NDY5MTZ8MTU1MTQwMzUwMy4xMQ"
    
    static let placeholderURL = "https://placebear.com"
}

enum APIPath: String {
    case events = "/events"
    case venues = "/venues"
    case performer = "/performer"
}

class NetworkService {
    
    func baseURLComponents(path : APIPath, size: Int) -> URLComponents{
        var urlComponents = URLComponents()
        urlComponents.scheme = URLs.scheme
        urlComponents.host = URLs.host
        urlComponents.path = path.rawValue
        let apiKeyQuery = URLQueryItem(name: "client_id", value: URLs.api_key)
        //should pull this out.
        let pageSizeQuery = URLQueryItem(name: "per_page", value: String(size))
        urlComponents.queryItems = [apiKeyQuery, pageSizeQuery]
        
        return urlComponents
    }
    
    func baseURLComponents(path : APIPath, searchTerm : String, size: Int) -> URLComponents{
        var urlComponents = baseURLComponents(path: path, size: size)
        urlComponents.queryItems?.append(URLQueryItem(name: "q",
                                                      value: searchTerm.replacingOccurrences(of: " ", with: "+")))
        
        return urlComponents
    }
    
    
    func download (link: URL, completion: @escaping (_ data :Data?, _ error :Error?) -> Void){
        
        URLSession.shared.dataTask(with: link){
            (data, response, error) in
            
            guard error == nil else{
                
                completion(nil, error)
                return
            }
            
            completion(data, nil)
            }.resume()
    }
}
