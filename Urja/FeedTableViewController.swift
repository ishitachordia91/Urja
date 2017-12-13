//
//  FeedTableViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 8/8/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit
import CloudKit

class FeedTableViewController: UITableViewController {
    
    var currRecord: CKRecord?
    
    //MARK: - View Life Cycle
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = activityIndicatorView
        activityIndicatorView.center = self.tableView.center
        self.view.addSubview(activityIndicatorView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        if(fetchedData.count <= 0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            activityIndicatorView.startAnimating()
            if(NSUserDefaults.standardUserDefaults().valueForKey("usedFbLogin") as! NSInteger as Int == 1) {
                let friendList = NSUserDefaults.standardUserDefaults().valueForKey("friendList")?.mutableCopy() as! NSMutableArray
                let predFriends = NSPredicate(format: "FbId IN %@", friendList)
                loadData(predFriends)
            } else {
                loadData(NSPredicate(value:true))
            }
        }
    }

    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FeedTableViewCell
        let record = fetchedData[indexPath.row]
        let datetime = record!.valueForKey("Date") as! NSString
        let day = datetime.substringToIndex(datetime.length - 9)
        cell.date.text = "\(day)"
        let name = record!.valueForKey("Name") as! NSString as String
        let cardEnergy = record!.valueForKey("CardType") as! NSString as String
        let deed = record!.valueForKey("KindDeed") as! NSString as String
        cell.title.text = "\(name) \(deed)"
        cell.profPic.image = UIImage(named: "\(cardEnergy)_small.jpg")
        return cell
    }

    func stringURLToImage(record: NSString)->UIImage {
        let url = NSURL(string: record as String)
        let profPicData: NSData = NSData(contentsOfURL: url!)!
        return UIImage(data: profPicData)!
    }
    
    

    //MARK: - Model
    var fetchedData: Array<CKRecord?> = []
    private var countNumberReloads = 0
    
    func loadData(pred : NSPredicate) {
        let query = CKQuery(recordType: "Card", predicate: pred)
        
        CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil)
        { (results, error) -> Void in
            if error != nil {   //if there's an error
                self.countNumberReloads+=1
                if(self.countNumberReloads < 15) {
                    self.loadData(pred)
                } else {
                    let ac = UIAlertController(title: "Network Error", message: "Please try accessing this page again later", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) -> Void in
                        self.performSegueWithIdentifier("HomeSegue", sender: nil)
                    })
                    ac.addAction(okAction)
                    self.presentViewController(ac, animated: true, completion: nil)
                }
            }
            else {
                var count = 0
                for result in results! {
                    self.fetchedData.append(result)
                    count = count+1
                    if(count > 100) {
                        break
                    }
                }
                if let myCurrRecord = self.currRecord {
                    self.fetchedData.insert(myCurrRecord, atIndex: 0)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if(self.fetchedData.count <= 0) {
                        self.loadData(NSPredicate(value:true))
                    } else {
                        //Sort array by date
                        if(self.fetchedData.count > 1) {
                            let formatter = NSDateFormatter()
                            formatter.dateFormat = "MMMM d, yyyy HH:mm:ss"
                            //formatter.locale = NSLocale.
                            self.fetchedData.sortInPlace{ (element1, element2) -> Bool in
                                let e1 = formatter.dateFromString(element1!.valueForKey("Date") as! NSString as String)
                                let e2 = formatter.dateFromString(element2!.valueForKey("Date") as! NSString as String)
                                let distanceBetweenDates = e2!.timeIntervalSinceDate(e1!)
                                return distanceBetweenDates < 0
                            }
                        }
                        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                        self.tableView.reloadData()
                    }
                    self.activityIndicatorView.stopAnimating()
                })
            }
        }
    }
    
    
}



//TABLE VIEW CELL
class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    
}


