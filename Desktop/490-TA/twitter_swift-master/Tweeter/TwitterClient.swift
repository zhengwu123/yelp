//
//  TwitterClient.swift
//  Tweeter
//
//  Created by zheng wu on 2/11/16.
//  Copyright © 2016 zheng wu. All rights reserved.
//

//import Cocoa
import BDBOAuth1Manager

let twitterConsumerKey = "dXpqJM7saUm835S4jYMK282b4"
let twitterConsumerSecret = "eArJFNK4VVnVylAT2DS78mETEXU0AcclbAGcZiutly02Jnav6K"
let twitterBaseURL = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    
    enum NetworkRequest {
        case get, post
    }
    
    var loginCompletion: ((_ user: User?, _ error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    func retweet(_ id: String, completion: @escaping (_ tweet: Tweet?, _ error: NSError?) -> ()) {
        let url = "1.1/statuses/retweet/\(id).json"
        requestTwitterWithTweetResponse(NetworkRequest.post, url: url, queryParams: nil, parameters: nil, completion: completion)
    }
    
    func unretweet(_ id: String, completion: @escaping (_ tweet: Tweet?, _ error: NSError?) -> ()) {
        let url = "1.1/statuses/unretweet/\(id).json"
        requestTwitterWithTweetResponse(NetworkRequest.post, url: url, queryParams: nil, parameters: nil, completion: completion)
    }
    
    func favorite(_ id_str: String, completion: @escaping (_ tweet: Tweet?, _ error: NSError?) -> ()) {
        let url = "1.1/favorites/create.json"
        requestTwitterWithTweetResponse(NetworkRequest.post, url: url, queryParams: ["id" : id_str], parameters: nil, completion: completion)
    }
    
    func unfavorite(_ id_str: String, completion: @escaping (_ tweet: Tweet?, _ error: NSError?) -> ()) {
        let url = "1.1/favorites/destroy.json"
        requestTwitterWithTweetResponse(NetworkRequest.post, url: url, queryParams: ["id" : id_str], parameters: nil, completion: completion)
    }
    
    func buildURLWithQueryParams(_ url: String, queryParams: [String:String]?) -> String {
        var urlWithQueryParams = url
        if queryParams != nil {
            urlWithQueryParams.append("?")
            for qp in queryParams! {
                let qp1: String = qp.1.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                urlWithQueryParams.append(qp.0 + "=" + qp1 + "&")
            }
        }
        if urlWithQueryParams[urlWithQueryParams.characters.index(before: urlWithQueryParams.endIndex)] == "&" {
            urlWithQueryParams = String(urlWithQueryParams.characters.dropLast())
        }

        return urlWithQueryParams
    }
    
    func requestTwitter(_ mode: NetworkRequest, url: String, queryParams: [String:String]?, parameters: NSDictionary?, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> ()) {
        
        let urlWithQueryParams = buildURLWithQueryParams(url , queryParams: queryParams)
        if mode == NetworkRequest.get {
            get(urlWithQueryParams, parameters: parameters, success:  { (operation: AFHTTPRequestOperation!, response: Any!) -> Void in
                completion(response as AnyObject?, nil)
                }, failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                    completion(nil, error as NSError?)
            })
        } else if mode == NetworkRequest.post {
            
            post(urlWithQueryParams, parameters: parameters, success:  { (operation: AFHTTPRequestOperation!, response: Any!) -> Void in
                    completion(response as AnyObject?, nil)
                }, failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                    completion(nil, error as NSError?)
            })
        } else {
            print("requestTwitter with unknown mode: \(mode)")
        }
    }
    
    func requestTwitterWithTweetResponse(_ mode: NetworkRequest, url: String, queryParams: [String:String]?, parameters: NSDictionary?, completion: @escaping (_ tweet: Tweet?, _ error: NSError?) -> ()) {
        requestTwitter(NetworkRequest.post, url: url, queryParams: queryParams, parameters: parameters) {
            (response: AnyObject?, error: NSError?) in
            var tweet: Tweet? = nil
            if response != nil {
                tweet = Tweet(dictionary: response as! NSDictionary)
            }
            completion(tweet, error)
        }
    }
    
    func homeTimelineWithParams(_ parameters: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error:NSError?) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: ["include_entities": true], success:  { (operation: AFHTTPRequestOperation!, response: Any?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets, nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
                completion(nil, error as NSError?)
        })
    }
    
    func publishTweet(_ text: String, in_reply_tweet_id: Int?, completion: @escaping (_ tweet: Tweet?, _ error: NSError?) -> ()) {
        let url = "1.1/statuses/update.json"
        var queryParams = ["status": text]
        if in_reply_tweet_id != nil {
            queryParams["in_reply_to_status_id"] =  "\(in_reply_tweet_id!)"
        }
        
        requestTwitterWithTweetResponse(NetworkRequest.post, url: url, queryParams: queryParams, parameters: nil, completion: completion)
    }
    
    func loginWithCompletion(_ completion: @escaping (_ user: User?, _ error: NSError?) -> ()) {
        self.loginCompletion = completion
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"tweetiepy://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            let url = String(describing: authURL)
            print(url)
            
            
            UIApplication.shared.openURL(authURL!)
            }, failure: { (error: Error? ) -> Void in
                print("Failed to get token")
        })
    }
    
    func openURL(_ url: URL) {
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Got access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, success:  { (operation: AFHTTPRequestOperation!, response: Any!) -> Void in
                    let user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    self.loginCompletion?(user, nil)
                }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
                    (self.loginCompletion?(nil, error as NSError?))!
                    
            })

            }, failure: {
                (error: Error?) -> Void in
                print("Failed to get access token")
                self.loginCompletion?(nil, error as NSError?)
        })
    }
}
