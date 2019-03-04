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
    
    var favoriteBarButtonItem : UIBarButtonItem?
    
    //how can we initialize with this value
    var eventViewModel : EventViewModel?
    var eventViewControllerCustomTitleView : EventViewControllerCustomTitleView?
    
    weak var delegate: EventViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
        setupDataFromEvent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target : self, action :#selector(EventViewController.dismissViewController))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        if let eventModel = eventViewModel{
            //Load from nib extension
            let eventTitleView = Bundle.loadView(fromNib: "EventViewControllerCustomTitleView", withType: EventViewControllerCustomTitleView.self)
            
            eventTitleView.eventTitleLabel.text = eventModel.titleDisplayString()
            eventTitleView.eventTitleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150)
            self.eventViewControllerCustomTitleView = eventTitleView
            self.navigationItem.titleView = eventViewControllerCustomTitleView
        }
        
        setupButton()
    }
    
    func setupButton () {
        
        guard let eventModel = eventViewModel else {
            print("Setting up favorite button without EventModel")
            return
        }
        
        var favoriteButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EmptyHeart"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(action(_:)))
        
        if(eventModel.isFavoriteEvent()){
            favoriteButton = UIBarButtonItem(image: UIImage(named: "Heart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(action(_:)))
        }
        
        self.favoriteBarButtonItem = favoriteButton
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func setupDataFromEvent() {

        if let eventModel = eventViewModel{
            eventLocationLabel.text = eventModel.venueLocationDisplayString()
            eventDateLabel.text = eventModel.dateDisplayString()
            
            //LoadImage
            let imageURLTuple = eventModel.venueImageURLStringTuple()
            self.eventImageView.loadImage(with: imageURLTuple.imageUrl,
            appendSize: imageURLTuple.needsSize)
        }else{
            print("EventViewController : Loaded without EventModel!")
        }
    }
    
    @IBAction func action(_ sender: UIBarButtonItem) {
        if let isFavorite = eventViewModel?.isFavoriteEvent(){
            //We can animate from here, will probably need to embed UIbarbutton in bar button item.
            if(!isFavorite){
                let favoriteButton = UIBarButtonItem(image: UIImage(named: "Heart"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(action(_:)))
                navigationItem.rightBarButtonItem = favoriteButton
            }else{
                 let favoriteButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "EmptyHeart"),
                                                                       style: .plain,
                                                                       target: self,
                                                                       action: #selector(action(_:)))
                navigationItem.rightBarButtonItem = favoriteButton
            }
            
            
            
            eventViewModel?.selectedAsFavorite(!isFavorite)
            self.delegate?.eventMarkedAsFavorite(eventViewModel!)
            
            //setupButton()
            
        }
    }
}
