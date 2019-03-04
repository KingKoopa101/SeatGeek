//
//  Extensions.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/3/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}

import Kingfisher

extension UIImageView {
    func loadImage(with imageURLString : String, isPlaceholder: Bool){
        
        var URLstring = imageURLString
        
        if isPlaceholder {
            
            let width : Int = Int(frame.size.width)
            let height : Int = Int(frame.size.height)
            
            URLstring = imageURLString + "/\(width)/\(height)"
        }
        
        guard let imageURL = URL(string: URLstring) else {
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 10)
        self.kf.setImage(with: imageURL, options: [.processor(processor)])
    }
}
