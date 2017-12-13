//
//  SendEnergyTableViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 5/8/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit

var cardType: String!

class SendEnergyTableViewController: UITableViewController {
    
    
    //MARK: - Model
    
    var imageList = ["lovestone.jpg", "horseshoe.jpg", "joyflower.jpg", "mountain.jpg"]
    var labelList = ["love", "luck", "joy", "strength"]
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = (self.tableView.frame.size.height - (self.navigationController?.navigationBar.frame.height)!) / 4.0
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SendEnergyTableViewCell
        cell.sendEnergyImage.image = UIImage(named: imageList[indexPath.row])
        cell.sendEnergyLabel.text = labelList[indexPath.row]
        return cell
    }
    
    
    // MARK: - Transition
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cardTypeInt = indexPath.row
        switch cardTypeInt {
        case 0:
            cardType = "love"
        case 1:
            cardType = "luck"
        case 2:
            cardType = "hugs"
        case 3:
            cardType = "strength"
        default:
            break;
        }
    }
    
}



//TABLE VIEW CELL
class SendEnergyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sendEnergyImage: UIImageView!
    @IBOutlet weak var sendEnergyLabel: UILabel!
    
}
