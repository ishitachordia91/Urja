//
//  SuggestionsViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 2/14/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit

var chosenDeed: String?

extension UIView {
    func rotate(toValue: CGFloat, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = toValue
        rotateAnimation.duration = 0.2
        rotateAnimation.removedOnCompletion = false
        rotateAnimation.fillMode = kCAFillModeForwards
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}


//TABLE VIEW CONTROLLER
class SuggestionsTableViewController: UITableViewController, UITextViewDelegate {
    
    
    //MARK: - Model
    
    var kindDeedsData = Suggestions().sectionsData
    var kindDeedsPastData = Suggestions().sectionsDataPastTense
    let originalUserEntered: String! = "e.g., \"helped someone cross the road\""
    var userEntered: String!
    
    @IBOutlet weak var textViewCell: SuggestionsTextViewTableViewCell!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = (self.tableView.frame.size.height - 8.0 - (self.navigationController?.navigationBar.frame.height)!) / CGFloat(kindDeedsData.count)
        userEntered = originalUserEntered
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (kindDeedsData[section].collapsed == true) ? 0 : kindDeedsData[section].items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell1:SuggestionsTextViewTableViewCell? = nil
        var cell2:SuggestionsItemsTableViewCell? = nil
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            cell1 = tableView.dequeueReusableCellWithIdentifier("textviewCell") as! SuggestionsTextViewTableViewCell!
            if(kindDeedsPastData[indexPath.section].items[indexPath.row] == "") {
                cell1?.textViewLabel.text = originalUserEntered
            } else {
                cell1?.textViewLabel.text = kindDeedsPastData[indexPath.section].items[indexPath.row]
            }
            cell1?.textViewLabel.layer.borderWidth = 1.5
            cell1?.textViewLabel.layer.cornerRadius = 8.0
            cell1?.textViewLabel.layer.borderColor = UIColor.grayColor().CGColor
            cell1?.textViewLabel.textColor = UIColor.grayColor()
            cell1?.textViewLabel.tintColor = UIColor.blackColor()
            cell1?.textViewLabel.delegate = self
        } else {
            cell2 = tableView.dequeueReusableCellWithIdentifier("cell") as! SuggestionsItemsTableViewCell!
            cell2!.itemLabel.text = kindDeedsData[indexPath.section].items[indexPath.row]
        }
        //keep chosen deeds highlighted
        if(chosenDeedArr.contains(kindDeedsPastData[indexPath.section].items[indexPath.row])) {
            let rowToSelect:NSIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
            self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: .None)
            self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect)
        }
        if(indexPath.section == 0 && indexPath.row == 0) {
            return cell1!
        } else {
            return cell2!
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kindDeedsData.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCellWithIdentifier("header") as! SuggestionsTableViewCell
        header.titleLabel.setTitle(kindDeedsData[section].name, forState: .Normal)
        header.backgroundImage.image = UIImage(named: "texture.jpg")
        header.titleLabel.tag = section
        header.toggleButton.tag = section
        header.toggleButton.rotate((kindDeedsData[section].collapsed == true) ? 0.0 : CGFloat(M_PI_2))
        header.toggleButton.addTarget(self, action: #selector(SuggestionsTableViewController.toggleCollapse), forControlEvents: .TouchUpInside)
        header.titleLabel.addTarget(self, action: #selector(SuggestionsTableViewController.toggleCollapse), forControlEvents: .TouchUpInside)
        return header.contentView
    }
    
    func toggleCollapse(sender: UIButton) {
        let section = sender.tag
        kindDeedsData[section].collapsed = !kindDeedsData[section].collapsed
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
    }
    
    
    
    // MARK: - Selection
    var chosenDeedArr:Array<String> = []
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        kindDeedsPastData[0].items[0] = userEntered
        if(!chosenDeedArr.contains(kindDeedsPastData[indexPath.section].items[indexPath.row])) {
            chosenDeedArr.append(kindDeedsPastData[indexPath.section].items[indexPath.row])
        }
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if(chosenDeedArr.contains(kindDeedsPastData[indexPath.section].items[indexPath.row])) {
        let currIndex = chosenDeedArr.indexOf(kindDeedsPastData[indexPath.section].items[indexPath.row])
        chosenDeedArr.removeAtIndex(currIndex!)
        }
    }
    
    
    //MARK: - Text View Delegates
    
    private var finishedEditing: Bool? = nil
    func textViewDidBeginEditing(textView: UITextView) {
        textView.becomeFirstResponder()
        //call deselectHere
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0);
        self.tableView.deselectRowAtIndexPath(rowToSelect, animated: true)
        self.tableView(self.tableView, didDeselectRowAtIndexPath: rowToSelect)
        textView.textColor = UIColor.blackColor()
        textView.text = nil
        finishedEditing = false
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        let input = (textView.text).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        kindDeedsPastData[0].items[0] = input as String
        userEntered = input as String
        if(input != "" && finishedEditing != nil && finishedEditing! == true) {
            //call selectHere
            let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0);
            self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
            self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect)
        }
        finishedEditing = true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            finishedEditing = true
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        userEntered = (textView.text).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as String
    }
    
    //MARK: - Privacy
    
    @IBAction func setPrivacy(sender: UIBarButtonItem) {
        savedRecordYet = false
        if(chosenDeedArr.count > 0) {
            let alertController = UIAlertController(title: "", message: "Share Your Kind Deed On The Activity Feed?", preferredStyle: .ActionSheet);
        
            let button1 = UIAlertAction(title: "sure, that's ok", style: .Default, handler:
                { action in
                    chosenDeed = ((self.chosenDeedArr[0]).lowercaseString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    self.performSegueWithIdentifier("Card", sender: self)
                }
            )
            let button2 = UIAlertAction(title: "  no, I'd rather not  ", style: .Default, handler :
                { action in
                    chosenDeed = ((self.chosenDeedArr[0]).lowercaseString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    self.performSegueWithIdentifier("Card", sender: self)
                }
            )
            let button3 = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(button1)
            alertController.addAction(button2)
            alertController.addAction(button3)
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        } else {
            chosenDeed = nil
            self.performSegueWithIdentifier("Card", sender: self)
        }
    }
    
}



//HEADER CELL
class SuggestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var titleLabel: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
}


//TEXT CELL
class SuggestionsItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
}

//TEXTVIEW CELL
class SuggestionsTextViewTableViewCell: UITableViewCell {
    @IBOutlet weak var textViewLabel: UITextView!
}
