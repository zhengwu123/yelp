//
//  ComposeViewController.swift
//  Tweeter
//
//  Created by zheng wu on 2/11/16.
//  Copyright © 2016 zheng wu. All rights reserved.
//

import UIKit
let tweetCreatedNotification = "ntweetCreated"
let tweetCreatedKey = "ktweetCreated"

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var composerTextView: UITextView!
    @IBOutlet weak var composerPlaceholderLabel: UILabel!
    var inReplyToTweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = User.currentUser?.name
        self.usernameLabel.text = "@\((User.currentUser?.screenname)!)"
        self.composerTextView.delegate = self
        updateNumChars()
        self.profileImageView.setImageWith(URL(string: (User.currentUser?.profileImageUrl)!)!)
        if inReplyToTweet != nil {
            self.composerTextView.text = "@\((inReplyToTweet?.user!.screenname)!) "
            self.composerPlaceholderLabel.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(_ sender: AnyObject) {
        var userInfo: [AnyHashable: Any] = [:]
        Tweet.publishTweet(self.composerTextView.text!, in_reply_tweet_id: inReplyToTweet?.tweetID)  {
            (tweet: Tweet?, error:NSError?) in
            if error != nil {
                print("Failed to post tweet")
                print(error!)

            } else {
                print("Posted post \(tweet)")
                userInfo[tweetCreatedKey] = tweet
                NotificationCenter.default.post(name: Notification.Name(rawValue: tweetCreatedNotification), object: self, userInfo: userInfo)
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.composerPlaceholderLabel.isHidden = true
        if self.composerTextView.text!.characters.count > 139 {
            self.composerTextView.isEditable = false
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.composerTextView.text!.characters.count > 0 {
            self.composerPlaceholderLabel.isHidden = true
        }
        if self.composerTextView.text!.characters.count > 139 {
        self.composerTextView.isEditable = false
        }
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateNumChars()
    }
    
    func updateNumChars() {
        let numChars = 140 - self.composerTextView.text!.characters.count
        self.characterCountLabel.text = "\(numChars)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
