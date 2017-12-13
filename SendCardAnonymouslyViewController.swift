//
//  SendCardAnonymouslyViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 12/30/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit
import ContactsUI

class SendCardAnonymouslyViewController: UIViewController, CNContactPickerDelegate, UITextViewDelegate {

    //set from previous view controller
    var imagePath: NSURL?
    //set during view cycle
    var imageCard: UIImage?
    var name: String!
    var originalMessageImageContainerToSubjectTextFieldConstraintConstant: CGFloat!
    
    //objects on the view controller
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var postcardImageView: UIImageView!
    @IBOutlet weak var emailBodyTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var toEmailTextField: UITextField!
    @IBOutlet weak var bccTextField: UITextField!
    @IBOutlet weak var fromEmailLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var bccLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var messageImageContainerToSubjectTextFieldConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toContactsButton: UIButton!
    @IBOutlet weak var bccContactsButton: UIButton!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailBodyTextView.text = "You've received some positive energy and good vibes from a friend! \nDownload Urja on the ios app store and spread your own good vibes."
        subjectTextField.text = "Sending you \(cardType)!"
        imageCard = UIImage(contentsOfFile: imagePath!.path!)!
        postcardImageView.image = imageCard
        savedRecordYet = false
        hideKeyboardWhenTappedAround()
        emailBodyTextView.delegate = self
        originalMessageImageContainerToSubjectTextFieldConstraintConstant = messageImageContainerToSubjectTextFieldConstraint.constant
    }
    
    override func viewDidLayoutSubviews() {
        emailBodyTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    //MARK: - Get Access to Contacts
    var emailAddressesString = ""
    var senderButton = "To"
    
    @IBAction func seeContacts(sender: UIButton) {
        senderButton = "To"
        showEmailContacts()
    }
    
    
    @IBAction func seeContactsBCC(sender: UIButton) {
        senderButton = "BCC"
        showEmailContacts()
    }
    
    
    func showEmailContacts() {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        cnPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count >= 1", argumentArray: nil)
        self.presentViewController(cnPicker, animated: true, completion: nil)
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]){
        emailAddressesString = ""
        for contact in contacts {
            for email in contact.emailAddresses {
                emailAddressesString.appendContentsOf(email.valueForKey("value") as! String)
                emailAddressesString.appendContentsOf(" ")
            }
        }
        if(senderButton == "To") {
            toEmailTextField.text = toEmailTextField.text?.stringByAppendingString(emailAddressesString)
        } else {
            bccTextField.text = bccTextField.text?.stringByAppendingString(emailAddressesString)
        }
    }
    
    
    //MARK: - Editing Message Body
    
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.subjectTextField.hidden = true
            self.toEmailTextField.hidden = true
            self.bccTextField.hidden = true
            self.fromEmailLabel.hidden = true
            self.toLabel.hidden = true
            self.bccLabel.hidden = true
            self.fromLabel.hidden = true
            self.subjectLabel.hidden = true
            self.toContactsButton.hidden = true
            self.bccContactsButton.hidden = true
            self.messageImageContainerToSubjectTextFieldConstraint.constant = -1 * (self.originalMessageImageContainerToSubjectTextFieldConstraintConstant*3 + self.subjectTextField.frame.height+self.bccTextField.frame.height+self.toEmailTextField.frame.height+self.fromEmailLabel.frame.height)
        })
        view.layoutIfNeeded()
    }
    
    @objc func moveDown() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.subjectTextField.hidden = false
            self.toEmailTextField.hidden = false
            self.bccTextField.hidden = false
            self.fromEmailLabel.hidden = false
            self.toLabel.hidden = false
            self.bccLabel.hidden = false
            self.fromLabel.hidden = false
            self.subjectLabel.hidden = false
            self.toContactsButton.hidden = false
            self.bccContactsButton.hidden = false
            self.messageImageContainerToSubjectTextFieldConstraint.constant =  self.originalMessageImageContainerToSubjectTextFieldConstraintConstant
        })
        view.layoutIfNeeded()
    }
    

    //MARK: - Send Email
    
    @IBAction func sendEmail(sender: UIButton) {
        let subjectUser = subjectTextField.text
        let bodyUser = emailBodyTextView.text
        
        //put each of the email addresses into an array
        let toEmailAddresses = toEmailTextField.text!.characters.split(" ").map(String.init)
        let bccEmailAddresses = bccTextField.text!.characters.split(" ").map(String.init)
        
        //check if email addresses are valid
        let toEmailsValid = Settings().checkIfValidEmailAddresses(toEmailAddresses)
        if(toEmailAddresses.count == 0) {
            Settings().presentOKAlertController("Invalid Email Addresses", messageBody: "Please enter at least 1 email addresses in the 'To' field", vc: self)
        }
        if(!toEmailsValid) {
            Settings().presentOKAlertController("Invalid Email Addresses", messageBody: "One or more of the email addresses in the 'To' field are invalid", vc: self)
        }
        let bccEmailsValid = Settings().checkIfValidEmailAddresses(bccEmailAddresses)
        if(!bccEmailsValid) {
            Settings().presentOKAlertController("Invalid Email Addresses", messageBody: "One or more of the email addresses in the 'BCC' field are invalid", vc: self)
        }
        if(bccEmailsValid && toEmailsValid && toEmailAddresses.count > 0) {
            sendAnonymousEmail(toEmailAddresses, subject: subjectUser!, body: bodyUser, bccEmailAddresses: bccEmailAddresses)
        }
    }
    
    
    
    func sendAnonymousEmail(toEmailAddresses: Array<String>, subject: String, body: String, bccEmailAddresses: Array<String>) {
        print("sending email")
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "urjapositiveenergy@gmail.com"
        smtpSession.password = "Himanshu1!"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.SASLPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let builder = MCOMessageBuilder()
        var toEmailAddressesMCOFormat: Array<MCOAddress> = []
        for email in toEmailAddresses {
            let emailMCO = MCOAddress(displayName: "", mailbox: email)
            if(!toEmailAddressesMCOFormat.contains(emailMCO)) {
                toEmailAddressesMCOFormat.append(emailMCO)
            }
        }
        var bccEmailAddressesMCOFormat: Array<MCOAddress> = []
        for email in bccEmailAddresses {
            let emailMCO = MCOAddress(displayName: "", mailbox: email)
            if(!bccEmailAddressesMCOFormat.contains(emailMCO)) {
                bccEmailAddressesMCOFormat.append(emailMCO)
            }
        }
        builder.header.bcc = bccEmailAddressesMCOFormat as [AnyObject]
        builder.header.to = toEmailAddressesMCOFormat as [AnyObject]
        builder.header.from = MCOAddress(displayName: "Urja App", mailbox: "urjapositiveenergy@gmail.com")
        builder.header.subject = subject
        builder.htmlBody = body
        
        //attach image
        var dataImage: NSData?
        dataImage = UIImageJPEGRepresentation(imageCard!, 1.0)!
        let attachment = MCOAttachment()
        attachment.mimeType =  "image/jpg"
        attachment.filename = "Urja_Card.jpeg"
        attachment.data = dataImage
        builder.addAttachment(attachment)
        
        let cardData = builder.data()
        let sendOperation = smtpSession.sendOperationWithData(cardData)
        sendOperation.start { (error) -> Void in
            if (error != nil) {
                Settings().presentOKAlertController("Error sending the email", messageBody: "Please try again or use an alternate method", vc: self)
            } else {
                SendCardViewController().cardSentSuccessfully()
                let ac = UIAlertController(title: "Card Send Successfully!", message: "Do you want to stay and send more emails or leave and lose any changes made to your card?", preferredStyle: .Alert)
                let goAction = UIAlertAction(title: "Leave", style: .Default, handler: {(action: UIAlertAction!) -> Void in
                    //Reset front of card
                    imageFrontCard = nil
                    messageFrontCard = nil
                    anonInstructionsHidden = nil
                    anonButtonImage = nil
                    self.performSegueWithIdentifier("SendCardAnonymouslyFeedSegue", sender: nil)
                })
                let stayAction = UIAlertAction(title: "Stay", style: .Default, handler: nil)
                ac.addAction(stayAction)
                ac.addAction(goAction)
                self.presentViewController(ac, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Keyboard
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SendCardAnonymouslyViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        moveDown()
        view.endEditing(true)
    }
    
    
    //MARK: - Navigation
    
    @IBAction func saveAndSegue(sender: AnyObject) {
        let ac = UIAlertController(title: "Stay or Go?", message: "Do you want to leave and lose any changes you've made to your card?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Default, handler: {(action: UIAlertAction!) -> Void in
            //Reset front of card
            imageFrontCard = nil
            messageFrontCard = nil
            anonInstructionsHidden = true
            anonButtonImage = nil
            self.performSegueWithIdentifier("SendCardAnonymouslyFeedSegue", sender: sender)
        })
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.presentViewController(ac, animated: true, completion: nil)
    }
}
