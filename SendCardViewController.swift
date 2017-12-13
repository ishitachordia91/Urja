//
//  SendCardViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 4/12/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit
import MessageUI
import FBSDKMessengerShareKit
import CloudKit


var savedRecordYet: Bool!

class SendCardViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    var imagePath: NSURL?
    var imageCard: UIImage?
    var currRecord: CKRecord?
    
    @IBOutlet weak var textsms: UIImageView!
    @IBOutlet weak var email: UIImageView!
    @IBOutlet weak var whatsapp: UIImageView!
    @IBOutlet weak var fbmessenger: UIImageView!
    @IBOutlet weak var textsmsButton: UIButton!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var fbmessengerButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCard = UIImage(contentsOfFile: imagePath!.path!)!
        Settings().roundedCorners(textsms, rounded: 8.0)
        Settings().roundedCorners(whatsapp, rounded: 8.0)
        Settings().roundedCorners(fbmessenger, rounded: 8.0)
        savedRecordYet = false
    }
 
    func cardSentSuccessfully() {
        if(!savedRecordYet && chosenDeed != nil) {
            saveRecord()
            savedRecordYet = true
        }
    }

    //MARK: Text/SMS Message
    @IBAction func sendText(sender: UIButton) {
        if !MFMessageComposeViewController.canSendText() {
            Settings().presentOKAlertController("Cannot Send Text Message", messageBody: "Your device is not able to send text messages", vc: self)
        } else if !MFMessageComposeViewController.canSendAttachments() {
            Settings().presentOKAlertController("Cannot Send Text Message", messageBody: "Your device is not able to send pictures via text messages", vc: self)
        } else {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = "Sending you \(cardType) and good vibes!\nDownload Urja from the ios app store to send your own."
            messageVC.addAttachmentData(UIImageJPEGRepresentation(imageCard!, 1.0)!, typeIdentifier: "image/jpeg", filename: "Urja_Card.jpeg")
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case .Cancelled, .Failed:
            self.dismissViewControllerAnimated(true, completion: nil)
            Settings().presentOKAlertController("Message failed to send", messageBody: "Please try again.", vc: self)
            break;
        case .Sent:
            self.dismissViewControllerAnimated(true, completion: nil)
            cardSentSuccessfully()
            break;
        }
    }
    
    
    
    //MARK: Email Message
    @IBAction func sendEmail(sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            Settings().presentOKAlertController("Email is unavailable", messageBody: "Please try an alternate method", vc: self)
        } else {
            let messageVC = MFMailComposeViewController()
            messageVC.mailComposeDelegate = self
            messageVC.setSubject("Sending you \(cardType)!")
            messageVC.addAttachmentData(UIImageJPEGRepresentation(imageCard!, 1.0)!, mimeType: "image/jpeg", fileName: "Urja_Card.jpeg")
            messageVC.setMessageBody("Download Urja on the ios app store and spread your own good vibes.", isHTML: false)
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch (result) {
        case .Cancelled, .Failed:
            self.dismissViewControllerAnimated(true, completion: nil)
            Settings().presentOKAlertController("Message failed to send", messageBody: "Please try again.", vc: self)
            break;
        case .Sent:
            self.dismissViewControllerAnimated(true, completion: nil)
            cardSentSuccessfully()
            break;
        default:
            break;
        }
    }
    
    //MARK: WhatsApp Message
    var documentController: UIDocumentInteractionController?
    @IBAction func sendWhatsApp(sender: UIButton) {
        let urlWA = "whatsapp://app"
        if let urlString = urlWA.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            if let whatsAppURL = NSURL(string: urlString) {
                
                if(UIApplication.sharedApplication().canOpenURL(whatsAppURL)) {
                    let viewToImage = ViewToImage()
                    let fileUrl = viewToImage.saveImageJPEG(imageCard!, name: "card.wai")
                    documentController = UIDocumentInteractionController(URL: fileUrl)
                    documentController!.delegate = self
                    documentController!.UTI = "net.whatsapp.image"
                    cardSentSuccessfully()
                    documentController!.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: false)
                } else {
                    Settings().presentOKAlertController("WhatsApp is unavailable", messageBody: "Please try an alternate method", vc: self)
                }
            }
        }
    }
    
    
    //MARK: FB Message
    @IBAction func sendFBMessage(sender: UIButton) {
        if(UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb-messenger://")!)) {
            // Installed
            FBSDKMessengerSharer.shareImage(imageCard, withOptions: nil)
            cardSentSuccessfully()
        } else {
            Settings().presentOKAlertController("Facebook Message is unavailable", messageBody: "Please try an alternate method", vc: self)
        }
    }
    
    
    //Mark: Save deed to cloud
    func saveRecord() {
        let cloudInstance = Cloud()
        let currRecord = cloudInstance.createRecord()
        cloudInstance.saveRecord(currRecord)
    }
    
    //Segue
    @IBAction func saveAndSegue(sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Stay or Go?", message: "Do you want to leave and lose any changes you've made to your card?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Default, handler: {(action: UIAlertAction!) -> Void in
            //Reset front of card
            imageFrontCard = nil
            messageFrontCard = nil
            anonInstructionsHidden = nil
            anonButtonImage = nil
            self.performSegueWithIdentifier("SendCardFeedSegue", sender: sender)
        })
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.presentViewController(ac, animated: true, completion: nil)
    }

}
