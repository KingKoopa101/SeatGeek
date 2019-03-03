//
//  FavoriteButton.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/3/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit

//WIP - Could probably be used in a barbuttonItem

class FavoriteButton: UIButton {
    
    var isFavorite: Bool
    
    required init(selected: Bool = false) {
        // set isFavorite before super.init is called
        self.isFavorite = selected
        
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        // set other operations after super.init, if required
        setImage(UIImage(named : "unselectedImage"), for: .normal)
        setImage(UIImage(named : "selectedImage"), for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        // set isFavorite before super.init is called
        self.isFavorite = false

        super.init(frame: frame)

        setImage(UIImage(named : "unselectedImage"), for: .normal)
        setImage(UIImage(named : "selectedImage"), for: .selected)
    }
}
