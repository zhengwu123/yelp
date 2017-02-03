//
//  HomeViewController.swift
//  Tweeter
//
//  Created by zheng wu on 2/11/16.
//  Copyright © 2016 zheng wu. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var tweets: [Tweet]?
    var isMoreDataLoading = false
    @IBOutlet weak var tableView: UITableView!
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Network request to get initial data.
        Tweet.homeTimelineWithParams(nil) {
            (tweets: [Tweet]?, error: NSError?) in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: tweetCreatedNotification), object: nil, queue: OperationQueue.main) { (notification: Notification) -> Void in
            let createdTweet = notification.userInfo?[tweetCreatedKey] as? Tweet
            if createdTweet != nil {
                self.tweets?.insert(createdTweet!, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let destViewController = segue.destination

        if segue.identifier == "replySegue" {
            
            let button = sender as? UIButton
            let cell = button?.superview?.superview as? HomeTweetCell
            
            let navigationController = destViewController as? UINavigationController
            let composerViewController = navigationController?.topViewController as? ComposeViewController
            composerViewController?.inReplyToTweet = cell?.tweet

        } else if segue.identifier == "detailsSegue" {
            let cell = sender as? HomeTweetCell
            let detailsViewController = destViewController as? TweetViewController
            detailsViewController?.tweet = cell?.tweet
            
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        Tweet.homeTimelineWithParams(nil) {
            (refreshed_tweets: [Tweet]?, error: NSError?) in
            if refreshed_tweets != nil {
                self.tweets = refreshed_tweets
                self.tableView.reloadData()
            } else {
                print(error!)
            }
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTweetCell", for: indexPath) as! HomeTweetCell
        cell.tweet = self.tweets![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true

                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                Tweet.loadMoreHomeTimelineWithLastTweet((self.tweets?.last)!) {
                    (tweets: [Tweet]?, error: NSError?) in
                    if tweets != nil {
                        self.tweets?.append(contentsOf: tweets!)
                        self.loadingMoreView!.stopAnimating()
                        self.tableView.reloadData()
                        self.isMoreDataLoading = false
                    } else {
                        print("\(error)")
                    }
                }
            }
        }
    }
}
