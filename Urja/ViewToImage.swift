//
//  ViewToImage.swift
//  Urja
//
//  Created by Ishita Chordia on 4/14/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import Foundation

class ViewToImage {
    
    
    //Change UIView to UIImage
    func transformToImage(view: UIView)->UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    //Save the UIImage in the Document Directory as a JPEG
    func saveImageJPEG(selectedImage: UIImage, name: String)->NSURL {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //path where the jpg will be written to
        let filePath = "\(paths)/" + name
        let fileURL = NSURL(fileURLWithPath: filePath)
        
        removeExistingFile(filePath)
        UIImageJPEGRepresentation(selectedImage, 1.0)?.writeToFile(filePath, atomically: true)
        return fileURL
    }
    
    //Remove any files that exist with the given filePath
    private func removeExistingFile(filePath: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        }
        catch _ as NSError {
        }
    }
    
    
}
