//
//  User.swift
//  Tweeter
//
//  Created by zheng wu on 2/11/16.
//  Copyright © 2016 zheng wu. All rights reserved.
//

import UIKit

var _currentUser: User?
var currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary!
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: userDidLogoutNotification), object: nil)
    }
    
    class func loginWithCompletion(_ completion: @escaping (_ user: User?, _ error: NSError?) -> ()) {
        TwitterClient.sharedInstance.loginWithCompletion(completion)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
                if data != nil {
                    do {
                        if let dictionary = try JSONSerialization.jsonObject(with: data!,
                            options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String:AnyObject] {
        _currentUser = User(dictionary: dictionary as NSDictionary)
        }
        
                    } catch {
                        _currentUser = nil
                    }
                }
            }
            return _currentUser
        }
        
        set(user){
            _currentUser = user
            if _currentUser != nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user!.dictionary,
                        options:JSONSerialization.WritingOptions(rawValue: 0))
                    UserDefaults.standard.set(data, forKey: currentUserKey)
                    
                    
                } catch {
                    print("Serialization Failed")
                }
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            UserDefaults.standard.synchronize()

        }
    }
}
