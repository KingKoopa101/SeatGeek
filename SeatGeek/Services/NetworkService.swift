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
