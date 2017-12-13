//
//  FrontCardViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 5/8/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit
import ReplayKit
import MobileCoreServices


var imageFrontCard: UIImage?
var messageFrontCard: String?
var anonInstructionsHidden: Bool?
var anonButtonImage: UIImage?


class FrontCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var sendAnonymously: Bool!
    var name: String!
    let imagePicker = UIImagePickerController()
    
    //@IBOutlet weak var image: UIImageView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var stampView: UIView!
    @IBOutlet weak var anonInstructions: UILabel!
    @IBOutlet weak var anonButton: UIButton!
    @IBOutlet weak var anonButtonOption: UIButton!
    @IBOutlet weak var messageUIView: UIView!
    @IBOutlet weak var imageUIView: UIView!
    @IBOutlet weak var editInstructionLabelToCard: NSLayoutConstraint!
    @IBOutlet weak var editInstructionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(FrontCardViewController.displayPhotoAlertController))
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(recognizer)
        }
    }

   
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Make A Card For Them"
        name = NSUserDefaults.standardUserDefaults().valueForKey("name") as! NSString as String
        Settings().blinkOnOff(editInstructionLabel)
        if(anonInstructionsHidden == nil) {
            anonInstructionsHidden = true
        }
        sendAnonymously = !(anonInstructionsHidden!)
        hideKeyboardWhenTappedAround()
        settings()
        Settings().setShadow(frontView,  r: 0, b: 0, g: 0, a: 0.60)
        anonButtonOption.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        anonButtonOption.titleLabel?.numberOfLines = 0
        messageView.textContainer.maximumNumberOfLines = 8
        messageView.textContainer.lineBreakMode = .ByTruncatingTail
        messageView.delegate = self
        editInstructionLabel.sizeToFit()
        Settings().roundedCorners(editInstructionLabel, rounded: 4.0)
        //image picker
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = true
        
        //permancence- these might be saved from earliers
        anonInstructions.hidden = anonInstructionsHidden!
        if(anonButtonImage != nil)  {
            anonButton.setImage(anonButtonImage, forState: .Normal)
        }
        centerTextViewContentVertically()
        
        //no red lines for spell check
        messageView.resignFirstResponder()
        messageView.spellCheckingType = .No
        messageView.autocorrectionType = .No
        
    }
    

    
    //MARK: - Settings
    
    
    private func settings() {
        imageView.contentMode = .ScaleAspectFit
        switch cardType {
        case "love":
            imageView.image = UIImage(named: "sealions.png")
        case "luck":
            imageView.image = UIImage(named: "cat.png")
        case "hugs":
            imageView.image = UIImage(named: "dog.png")
        case "strength":
            imageView.image = UIImage(named: "eagle.png")
        default:
            break;
        }
        if(imageFrontCard != nil) {
            imageView.image = imageFrontCard
        }
        //If a message has already been written, use that
        if(messageFrontCard != nil) {
            messageView.text = messageFrontCard
        }
        //New message- but didn't want to share their deed or didn't choose a deed
        else if(chosenDeed == nil || chosenDeed == "spread positive energy") {
            messageView.text = "Your friend \(name) did a kind deed in your name. There are good vibes out there just for you!\n\n   -Urja Team"
        }
        //New message- did choose a deed and is ok sharing it
        else {
            let deed = chosenDeed!
            messageView.text = "Your friend \(name) \(deed) today and dedicated that act of kindness to you. There are good vibes out there just for you!\n\n   -Urja Team"
        }

    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        moveDown()
        view.endEditing(true)
    }

    
    func centerTextViewContentVertically() {
        var topCorrect = (messageView.frame.height - messageView.sizeThatFits(messageView.contentSize).height)/5
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
        messageView.contentSize.height = messageView.sizeThatFits(messageView.contentSize).height
        messageView.contentInset.top = topCorrect
    }
    
    //MARK: Image Picker
    
    func displayPhotoAlertController() {
        Settings().displayPhotoAlertController(imagePicker, vc: self)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        editInstructionLabel.alpha = 1.0
    }
    
    
    //User chooses a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        Settings().blinkOnOff(editInstructionLabel)
        if (mediaType.isEqualToString(kUTTypeImage as String)) {
            var pickedObject = info[UIImagePickerControllerEditedImage] as? UIImage
            if (pickedObject == nil) {
                pickedObject = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            imageView.image = pickedObject
            self.dismissViewControllerAnimated(true, completion: nil)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            Settings().blinkOnOff(editInstructionLabel)
        }
        editInstructionLabel.alpha = 1.0
    }
    
    
    //MARK: - Anonymize
    
    @IBAction func sendAnonymouslyButton(sender: UIButton) {
        if (sendAnonymously == false) {
            sendAnonymously = true
            anonInstructions.hidden = false
            anonButton.setImage(UIImage(named: "checkedbox.png"), forState: .Normal)
            messageView.text = messageView.text.stringByReplacingOccurrencesOfString("\(name) ", withString: "anonymously ")
        } else {
            sendAnonymously = false
            anonInstructions.hidden = true
            anonButton.setImage(UIImage(named: "box.png"), forState: .Normal)
            messageView.text = messageView.text.stringByReplacingOccurrencesOfString("anonymously ", withString: "\(name) ")
        }
    }
    
    
    //MARK: - Change Layout for keyboard
    
    func textViewDidEndEditing(textView: UITextView) {
        centerTextViewContentVertically()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.anonButtonOption.hidden = true
            self.anonButton.hidden = true
            self.anonInstructions.hidden = true
            self.editInstructionLabel.hidden = true
            if(self.editInstructionLabelToCard.constant == 18.0) {
                self.editInstructionLabelToCard.constant = -1*(self.editInstructionLabelToCard.constant+self.editInstructionLabel.frame.height-self.anonInstructions.frame.origin.y+self.editInstructionLabel.frame.origin.y + 6)
            }
        })
        view.layoutIfNeeded()
    }
    
    @objc func moveDown() {
        if(self.editInstructionLabelToCard.constant != 18.0) {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.anonButtonOption.hidden = false
                self.anonButton.hidden = false
                self.anonInstructions.hidden = !self.sendAnonymously
                self.editInstructionLabel.hidden = false
                self.editInstructionLabelToCard.constant = 18.0
            })
            view.layoutIfNeeded()
            Settings().blinkOnOff(editInstructionLabel)
        }
    }

    
    
    
    //MARK: - Transitions
    var coverImageCard: UIImage!
    var pathCard: NSURL?
    
    @IBAction func rightArrowSegue(sender: UIBarButtonItem) {
        view.endEditing(true)
        if(sendAnonymously != nil && sendAnonymously) {
            performSegueWithIdentifier("SendCardAnonymouslySegue", sender: nil)
        } else {
            performSegueWithIdentifier("SendCardSegue", sender: nil)
        }
    }
    
    
    @IBAction func leftArrowSegue(sender: UIBarButtonItem) {        
        let ac = UIAlertController(title: "Stay or Go?", message: "Do you want to leave and lose any changes you've made to your card?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Default, handler: {(action: UIAlertAction!) -> Void in
            //Reset front of card
            imageFrontCard = nil
            messageFrontCard = nil
            anonInstructionsHidden = true
            anonButtonImage = nil
            self.performSegueWithIdentifier("DoAKindDeedSegue", sender: sender)
        })
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //save card as image
        let viewtoimage = ViewToImage()
        coverImageCard = viewtoimage.transformToImage(frontView)
        pathCard = viewtoimage.saveImageJPEG(coverImageCard, name: "Urja_Card.jpeg")
        
        if(segue.identifier == "SendCardSegue" || segue.identifier == "SendCardAnonymouslySegue") {
            if(imageView.image != UIImage(named: "sealions.png") && imageView.image != UIImage(named: "cat") && imageView.image != UIImage(named: "dog.png") && imageView.image != UIImage(named: "eagle.png")) {
                imageFrontCard = imageView.image
            } else{
                imageFrontCard =  nil
            }
            messageFrontCard = messageView.text
            anonButtonImage = anonButton.currentImage
            anonInstructionsHidden = !sendAnonymously
        }
        if(segue.identifier == "SendCardSegue") {
            let nextVC = segue.destinationViewController as! SendCardViewController
            nextVC.imagePath = pathCard
        } else if(segue.identifier == "SendCardAnonymouslySegue") {
            let nextVC = segue.destinationViewController as! SendCardAnonymouslyViewController
            nextVC.imagePath = pathCard
        }
    }
    
    
    
}
