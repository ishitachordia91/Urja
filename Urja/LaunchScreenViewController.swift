//
//  LaunchScreenViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 9/6/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit

/*
Use this code to create a launch screen which I can then take a
picture of and use for LaunchScreen.Storyboard
*/

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Settings().setBackgroundGradient(self)
    }

}
