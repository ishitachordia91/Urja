//
//  Settings.swift
//  Urja
//
//  Created by Ishita Chordia on 8/15/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import Foundation

class Settings {
    
    let orangeColor = UIColor(red: (255/255.0), green: (130/255.0), blue: (80/255.0), alpha: 1)
    let redColor = UIColor(red: (255/255.0), green: (80/255.0), blue: (80/255.0), alpha: 1)
    
    //MARK:- View functions
    
    func setBackgroundGradient(vc: UIViewController) {
        let topColor = orangeColor
        let bottomColor = redColor
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = vc.view.bounds
        vc.view.layer.insertSublayer(gradientLayer, atIndex:0)
    }
    
    func setShadow(view: UIView, r: CGFloat, b: CGFloat, g: CGFloat, a: Float ) {
        view.layer.shadowColor = UIColor(red: (r/255.0), green: (b/255.0), blue: (g/255.0), alpha: CGFloat(a)).CGColor
        view.layer.shadowOpacity = a
        view.layer.shadowOffset = CGSizeMake(4.0, 4.0)
        view.layer.shadowRadius = 4
    }
    
    func roundedCorners(view: UIView, rounded: CGFloat) {
        view.layer.cornerRadius = rounded
        view.clipsToBounds = true
    }
    
    func addButtonBorder(button: UIButton) {
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.darkGrayColor().CGColor
    }
    
    //MARK: - Create Alerts
    
    func presentOKAlertController(titleMessage: String, messageBody: String, vc: UIViewController) {
        let ac = UIAlertController(title: titleMessage, message: messageBody, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        ac.addAction(okAction)
        vc.presentViewController(ac, animated: true, completion: nil)
    }
    
    //Display options so that user can pick a photo
    func displayPhotoAlertController(imagePicker: UIImagePickerController, vc: UIViewController) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet);
        
        let button1 = UIAlertAction(title: "Choose From Album", style: .Default, handler:
            { action in
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                vc.presentViewController(imagePicker, animated: true, completion: nil)
            }
        )
        
        let button2 = UIAlertAction(title: "Take A Picture", style: .Default, handler :
            { action in
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                vc.presentViewController(imagePicker, animated: true, completion: nil)
            }
        )
        
        let button3 = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(button1)
        alertController.addAction(button2)
        alertController.addAction(button3)
        dispatch_async(dispatch_get_main_queue(), {
            vc.presentViewController(alertController, animated: true, completion: nil)
        })
    }

    
    
    //MARK: - String functions
    
    func underlineText(text: String, start: Int)->NSMutableAttributedString {
        let textRange = NSMakeRange(start, text.characters.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
        return attributedText
    }
    
    func italicizeText(text: String, start: Int)->NSMutableAttributedString {
        let textRange = NSMakeRange(start, text.characters.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
        return attributedText
    }

    func checkIfValidEmailAddresses(addresses: Array<String>)->Bool {
        for email in addresses {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if(!emailTest.evaluateWithObject(email)) {
                return false
            }
        }
        return true
    }
    
    func checkIfHasAtLeastOneLetter(input: NSString)->Bool {
        let cset = NSCharacterSet.letterCharacterSet()
        let range = input.rangeOfCharacterFromSet(cset)
        if (range.location == NSNotFound) {
            return false
        } else {
            return true
        }
    }
    
    //Create labels
    
    func createTitleLabel(text: String, xPos: CGFloat, yPos: CGFloat, widthLabel: CGFloat, centerX: CGFloat, screen: UIView)->UILabel {

        let label1 = createLabel(text, xPos: xPos, yPos: yPos, widthLabel: widthLabel, heightLabel: screen.frame.height/3)
        label1.textColor = Settings().redColor
        label1.font = UIFont.systemFontOfSize(23.0, weight: UIFontWeightMedium)
        label1.sizeToFit()
        label1.center.x = centerX
        return label1
    }
    
    func createSubtitleLabel(text: String, xPos: CGFloat, yPos: CGFloat, widthLabel: CGFloat, centerX: CGFloat)->UILabel {
        let label1 = createLabel(text, xPos: xPos, yPos: yPos, widthLabel: widthLabel, heightLabel: 200)
        label1.font = UIFont.italicSystemFontOfSize(22.0)
        label1.textColor = Settings().orangeColor
        label1.sizeToFit()
        label1.center.x = centerX
        return label1
    }
    
    func createLabel(text: String, xPos: CGFloat, yPos: CGFloat, widthLabel: CGFloat, heightLabel: CGFloat)->UILabel {
        let label1 = UILabel(frame: CGRect(x: xPos, y: yPos, width: widthLabel, height: heightLabel))
        label1.text = text
        label1.textAlignment = .Center
        label1.numberOfLines = 0
        label1.lineBreakMode = .ByWordWrapping
        return label1
    }
    
    
    //Create image
    
    func createImage(imageName: String, xPos: CGFloat, yPos: CGFloat, widthImage: CGFloat, heightImage: CGFloat)->UIImageView {
        let imageView = UIImageView(frame: CGRect(x:xPos, y:yPos, width:widthImage, height:heightImage))
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }
    
    //View functionality
    
    func blinkOnOff(objectView: UIView) {
        objectView.alpha = 1.0
        UIView.animateWithDuration(3.2, delay: 0.0, options: [.Repeat,.Autoreverse], animations: {() -> Void in
            objectView.alpha = 0
            }, completion: { Void in
        })
    }
    
}
