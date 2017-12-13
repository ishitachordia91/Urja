//
//  IntroductionViewController.swift
//  Urja
//
//  Created by Ishita Chordia on 12/20/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class IntroductionViewController: UIViewController, FBSDKLoginButtonDelegate, UIScrollViewDelegate, UITextFieldDelegate {

    
    //MARK: - Objects, variables, and constraints found on view
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlToBottom: NSLayoutConstraint!
    var fbLoginButton: FBSDKLoginButton!
    var orLabel: UILabel!
    var emailLoginButton: UIButton!
    var nameLabel: UILabel!
    var enterNameTextField: UITextField!
    var emailDoneButton: UIButton!
    var subtitle4: UILabel!
    var userID: NSString?
    var friendList: Array<NSString> = []
    var name: NSString!
    var loggedInFb: NSInteger = 0
    
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set scroll view
        let margin = CGFloat(16.0)
        let topToTextView1 = CGFloat(34.0)
        let textView1ToTextView2 = CGFloat(4.0)
        let distTextView2ToScrollView = CGFloat(30.0)
        let frameWidth = self.view.frame.width
        
        //create titles
        let title1 = Settings().createTitleLabel("Do you know somebody who could use some positive energy?", xPos: margin, yPos: topToTextView1, widthLabel: frameWidth-2*margin, centerX: frameWidth/2, screen: self.view)
        let subtitle1 = Settings().createSubtitleLabel("Send them some.", xPos: margin, yPos: textView1ToTextView2+title1.frame.origin.y+title1.frame.height, widthLabel: frameWidth-2*margin, centerX: frameWidth/2)
        let title2 = Settings().createTitleLabel("Step 1:\nDo a kind deed in their name", xPos: (frameWidth+margin), yPos: topToTextView1, widthLabel: frameWidth-2*margin, centerX: frameWidth+frameWidth/2, screen: self.view)
        let title3 = Settings().createTitleLabel("Step 2:\nDedicate that kind deed to them and send good vibes their way", xPos:(frameWidth*2+margin), yPos: topToTextView1, widthLabel: frameWidth-2*margin, centerX: frameWidth*2+frameWidth/2, screen: self.view)
        let title4 = Settings().createTitleLabel("Urja", xPos: (frameWidth*3+margin), yPos: (self.view.frame.height)/6-6, widthLabel: frameWidth-2*margin, centerX: frameWidth*3+frameWidth/2, screen: self.view)
        subtitle4 = Settings().createSubtitleLabel("~spread good vibes~", xPos: frameWidth*3+margin, yPos: textView1ToTextView2+title4.frame.height+title4.frame.origin.y, widthLabel: frameWidth-2*margin, centerX: frameWidth*3+frameWidth/2)
        
        //create images
        let imageWidth = self.view.frame.width-2*margin
        let imageHeight = self.view.frame.height - (topToTextView1 + title1.frame.height + textView1ToTextView2 + subtitle1.frame.height + pageControlToBottom.constant + pageControl.frame.height + distTextView2ToScrollView + 16.0)
        let originImageY = topToTextView1 + title1.frame.height + textView1ToTextView2 + subtitle1.frame.height + distTextView2ToScrollView
        let imgOne = Settings().createImage("iphone_outline1.png", xPos: margin, yPos: originImageY, widthImage: imageWidth,heightImage: imageHeight)
        let imgTwo = Settings().createImage("iphone_outline2.png", xPos:frameWidth+margin, yPos: originImageY, widthImage:imageWidth,heightImage: imageHeight)
        let imgThree = Settings().createImage("iphone_outline3.png", xPos:frameWidth*2+margin, yPos: originImageY, widthImage:imageWidth,heightImage: imageHeight)

        
        //create login buttons
        fbLoginButton = FBSDKLoginButton.init(frame: CGRect(x:frameWidth*3+margin+24, y:(view.frame.height/10)+subtitle4.frame.origin.y+subtitle4.frame.height, width: frameWidth-10*margin, height: 32))
        fbLoginButton.titleLabel!.font = UIFont.systemFontOfSize(16.0)
        fbLoginButton.center.x = frameWidth*3+frameWidth/2
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "user_friends"]
        
        orLabel = Settings().createLabel("———— or ————", xPos: frameWidth*3+margin+24, yPos: fbLoginButton.frame.origin.y+fbLoginButton.frame.height+12, widthLabel: 300, heightLabel: 18)
        orLabel.font = UIFont.systemFontOfSize(15.0)
        orLabel.sizeToFit()
        orLabel.center.x = frameWidth*3+frameWidth/2
        orLabel.textColor = UIColor(red: (0/255.0), green: (24/255.0), blue: (77/255.0), alpha: 1)
        
        emailLoginButton = UIButton.init(frame: CGRect(x:frameWidth+margin+24, y:orLabel.frame.origin.y+orLabel.frame.height+10, width: frameWidth-10*margin, height: 28))
        emailLoginButton.setTitle("with your contact information", forState: .Normal)
        emailLoginButton.setTitleColor(UIColor(red: (60/255.0), green: (89/255.0), blue: (166/255.0), alpha: 1), forState: .Normal)
        emailLoginButton.titleLabel!.font = UIFont.systemFontOfSize(16.0)
        emailLoginButton.sizeToFit()
        emailLoginButton.titleLabel?.attributedText = Settings().underlineText(emailLoginButton.titleLabel!.text!, start: 0)
        emailLoginButton.center.x = frameWidth*3+frameWidth/2
        emailLoginButton.addTarget(self, action: #selector(IntroductionViewController.decidedToLoginWithEmail), forControlEvents: .TouchUpInside)
        
        //Email Login Form buttons
        nameLabel = Settings().createLabel("Name:", xPos: frameWidth*3+margin+20, yPos: orLabel.frame.origin.y+orLabel.frame.height+20, widthLabel: 80, heightLabel: 28)
        nameLabel.font = UIFont.systemFontOfSize(16.0)
        nameLabel.sizeToFit()
        nameLabel.hidden = true
        
        enterNameTextField = UITextField.init(frame: CGRect(x:nameLabel.frame.width+nameLabel.frame.origin.x+18, y:orLabel.frame.origin.y+orLabel.frame.height+14, width: frameWidth-90-nameLabel.frame.width, height: 32))
        enterNameTextField.addTarget(self, action: #selector(IntroductionViewController.startedEnteringName), forControlEvents: .EditingDidBegin)
        enterNameTextField.placeholder = "e.g., Jane Doe"
        enterNameTextField.borderStyle = .RoundedRect
        enterNameTextField.tintColor = UIColor.blackColor()
        enterNameTextField.hidden = true
        enterNameTextField.delegate = self

        emailDoneButton = UIButton.init(frame: CGRect(x:frameWidth*3+margin+20, y:enterNameTextField.frame.origin.y+enterNameTextField.frame.height+18, width: frameWidth-72, height: 30))
        emailDoneButton.setTitle("Sign in", forState: .Normal)
        emailDoneButton.titleLabel!.font = UIFont.systemFontOfSize(16.0)
        emailDoneButton.center.x = frameWidth*3+frameWidth/2
        emailDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        emailDoneButton.backgroundColor = UIColor(red: (60/255.0), green: (89/255.0), blue: (166/255.0), alpha: 1)
        emailDoneButton.addTarget(self, action: #selector(IntroductionViewController.signedInWithEmail), forControlEvents: .TouchUpInside)
        Settings().roundedCorners(emailDoneButton, rounded: 3.0)
        emailDoneButton.hidden = true
        
        //Settings
        scrollView.addSubview(imgOne)
        scrollView.addSubview(imgTwo)
        scrollView.addSubview(imgThree)
        scrollView.addSubview(title1)
        scrollView.addSubview(subtitle1)
        scrollView.addSubview(title2)
        scrollView.addSubview(title3)
        scrollView.addSubview(title4)
        scrollView.addSubview(subtitle4)
        scrollView.addSubview(fbLoginButton)
        scrollView.addSubview(orLabel)
        scrollView.addSubview(emailLoginButton)
        scrollView.addSubview(emailDoneButton)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(enterNameTextField)
        hideKeyboardWhenTappedAround()
        self.scrollView.contentSize = CGSize(width:frameWidth*4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
   
    }
    
    override func viewDidAppear(animated: Bool) {
        let walkedThroughIntroBefore = NSUserDefaults.standardUserDefaults().valueForKey("introductionDoneBefore") as! Bool?
        if(walkedThroughIntroBefore != nil && walkedThroughIntroBefore == true) {
            performSegueWithIdentifier("Home", sender: self)
        }
        if (loggedInFb == 1) {
            saveUserDefaults()
            performSegueWithIdentifier("Home", sender: self)
        }
    }
    
    
    //MARK: - Scroll View
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        let cp = Int(currentPage)
        self.pageControl.currentPage = cp
    }
    
    
    //MARK: - Grab information using Email Login
    @objc func decidedToLoginWithEmail(sender: UIButton) {
        emailLoginButton.hidden = true
        emailDoneButton.hidden = false
        nameLabel.hidden = false
        enterNameTextField.hidden = false
    }
    
    
    @objc func startedEnteringName(sender: UITextField) {
        scrollView.scrollEnabled = false
        moveUp()
    }
    
    @objc func signedInWithEmail(sender: UIButton) {
        let input = (enterNameTextField.text!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString //remove trailing whitespace
        if(!Settings().checkIfHasAtLeastOneLetter(input)) {
            Settings().presentOKAlertController("Help Us Give You The Best Experience", messageBody: "please enter your name", vc: self)
        } else {
            name = input.localizedCapitalizedString //capitalize every first letter
            userID = "na" as NSString
            loggedInFb = 0
            saveUserDefaults()
            performSegueWithIdentifier("Home", sender: self)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 28
        let currentString: NSString = textField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    //MARK: - Grab information using Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error == nil && !result.isCancelled) {
            returnUserData()
            returnUserFriends()
            loggedInFb = 1
        }
    }
    
    func returnUserData() {
        FBSDKGraphRequest.init(graphPath: "me", parameters:["fields": "id, name"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if (error == nil) {
                self.userID = result.valueForKey("id") as? NSString
                self.friendList.append(self.userID!)
                self.name = result.valueForKey("name") as? NSString
            } else {
                self.userID = ""
                self.name = ""
            }
        }
    }
    
    
    func returnUserFriends() {
        FBSDKGraphRequest.init(graphPath:"/me/friends", parameters:["fields": "id"]).startWithCompletionHandler { (connection,
            result, error) -> Void in
            if error == nil {
                let fbFriendsData : NSArray = result["data"] as! NSArray
                for fbData in fbFriendsData {
                    self.friendList.append(fbData["id"] as! NSString)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    
    
    //MARK:- Save NS User Defaults
    
    func saveUserDefaults() {
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(userID, forKey: "userID")
        prefs.setValue(friendList, forKey: "friendList")
        prefs.setValue(name, forKey: "name")
        prefs.setValue(loggedInFb, forKey: "usedFbLogin")
        prefs.setValue(true, forKey: "introductionDoneBefore")
    }
    
    
    //MARK: - Keyboard
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(IntroductionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        scrollView.scrollEnabled = true
        moveDown()
        view.endEditing(true)
    }
    
    
    //MARK: - Change Layout for keyboard
    
    private func moveUp() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.fbLoginButton.hidden = true
            self.orLabel.hidden = true
            self.nameLabel.frame.origin.y = self.subtitle4.frame.origin.y+self.subtitle4.frame.height+26
            self.enterNameTextField.frame.origin.y = self.subtitle4.frame.origin.y+self.subtitle4.frame.height+20
            self.emailDoneButton.frame.origin.y = self.enterNameTextField.frame.origin.y+self.enterNameTextField.frame.height+18
        })
        view.layoutIfNeeded()
    }
    
    
    private func moveDown() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.nameLabel.frame.origin.y = self.orLabel.frame.origin.y+self.orLabel.frame.height+20
            self.enterNameTextField.frame.origin.y = self.orLabel.frame.origin.y+self.orLabel.frame.height+14
            self.emailDoneButton.frame.origin.y = self.enterNameTextField.frame.origin.y+self.enterNameTextField.frame.height+18
        })
        self.fbLoginButton.hidden = false
        self.orLabel.hidden = false
        view.layoutIfNeeded()
    }

    
    

}
