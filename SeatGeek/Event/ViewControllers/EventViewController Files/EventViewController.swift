//
//  EventViewController.swift
//  SeatGeek
//
//  Created by Alberto Lopez on 3/2/19.
//  Copyright © 2019 Alberto Lopez. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class EventViewController : UIViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    //how can we initialize with this value
    var eventViewModel : EventViewModel?
    var eventViewControllerCustomTitleView : EventViewControllerCustomTitleView?
    
    weak var delegate: EventViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
        setupButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataFromEvent()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func dismissViewController() {
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
        }else{
            print("Unable to dismiss Navigation Controller")
        }
    }
    
    func setupUI() {
        //        setupUI()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"BackButton")!,
                                                                style: .done, target: self,
                                                                action: #selector(EventViewController.dismissViewController))
        
//        if let eventModel = eventViewModel{
//            /* label */
//
//            let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 88))
//            label.text = eventModel.titleDisplayString()
//            label.font = UIFont.systemFont(ofSize: 28)
//            label.textAlignment = .center
//            label.numberOfLines = 0
//            label.lineBreakMode = .byWordWrapping
//            label.backgroundColor = UIColor.red
//
//            self.navigationItem.titleView = label
//
//            eventViewControllerCustomTitleView?.layoutSubviews()
//            eventViewControllerCustomTitleView?.sizeToFit()
//
//        }
    }
    
    func setupButton () {
        let favoriteButton : UIBarButtonItem
        
        if(eventViewModel?.isFavoriteEvent() ?? false){
            favoriteButton = UIBarButtonItem(image: UIImage(named: "Heart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(action(_:)))
        }else{
            favoriteButton = UIBarButtonItem(image: UIImage(named: "EmptyHeart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(action(_:)))
        }
        
        
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func setupDataFromEvent() {

        if let eventModel = eventViewModel{
            eventLocationLabel.text = eventModel.venueLocationDisplayString()
            eventDateLabel.text = eventModel.dateDisplayString()
            
            title = eventModel.titleDisplayString()
            
            let imageURLTuple = eventModel.venueImageURLStringTuple()
            self.eventImageView.loadImage(with: imageURLTuple.imageUrl,
            appendSize: imageURLTuple.needsSize)
        }else{
            print("EventViewController : Loaded without EventModel!")
        }
    }
    
    @IBAction func action(_ sender: UIBarButtonItem) {
        if let isFavorite = eventViewModel?.isFavoriteEvent(){
            
            eventViewModel?.selectedAsFavorite(!isFavorite)
            self.delegate?.eventMarkedAsFavorite(eventViewModel!)
            
            setupButton()
        }
    }
}
