//
//  Cloud.swift
//  Urja
//
//  Created by Ishita Chordia on 8/8/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import Foundation
import CloudKit


class Cloud {
    
    let container = CKContainer.defaultContainer()
    let numLikes = 0
    
    //MARK:- Sending to the cloud
    
    func createRecord()->CKRecord {
        let timestamp = dateAsString(NSDate(), dstyle: .LongStyle, tstyle: .LongStyle) as String
        let id = CKRecordID(recordName: timestamp)
        let ud = NSUserDefaults.standardUserDefaults()
        
        let record = CKRecord(recordType: "Card", recordID: id)
        record.setObject(ud.valueForKey("name") as! NSString, forKey: "Name")
        record.setObject(ud.valueForKey("userID") as! NSString, forKey: "FbId")
        record.setObject(cardTypeAsString(cardType), forKey: "CardType")
        record.setObject(numLikes as NSNumber, forKey: "NumberOfLikes")
        record.setObject(chosenDeed! as NSString, forKey: "KindDeed")
        record.setObject(dateAsString(NSDate(), dstyle: .LongStyle, tstyle: .ShortStyle), forKey: "Date")
        return record
    }
    
    func saveRecord(record: CKRecord) {
        let publicDatabase = container.publicCloudDatabase
        publicDatabase.saveRecord(record, completionHandler:{ (record, error) -> Void in
            if (error != nil) {
                print("error saving to cloud")
            }
        })
    }
    
    func dateAsString(date: NSDate, dstyle: NSDateFormatterStyle, tstyle: NSDateFormatterStyle)-> NSString{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy HH:mm:ss"
        let dateString = formatter.stringFromDate(date)
        return dateString as NSString
    }
    
    func cardTypeAsString(cardType: String)->NSString {
        switch cardType {
        case "love":
            return "Love"
        case "luck":
            return "Luck"
        case "hugs":
            return "Joy"
        case "strength":
            return "Strength"
        default:
            break;
        }
        return "Love"
    }
}
