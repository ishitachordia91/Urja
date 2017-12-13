//
//  HomeViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 5/8/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

//Basically a way to send positive energy and good vibes to a friend and/or loved one.
//If you know someoene's having a rough time, can you put some positive energy out there for them?

import UIKit


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Settings().setBackgroundGradient(self)
        self.navigationController?.navigationBarHidden = true
        Settings().setShadow(button1, r: 128.0, b: 128.0, g: 128.0, a: 0.75)
        Settings().setShadow(button2, r: 128.0, b: 128.0, g: 128.0, a: 0.75)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func segueToActivityFeed(sender: UIButton) {
        super.performSegueWithIdentifier("HomeFeedSegue", sender: sender)
    }
    
    
}
