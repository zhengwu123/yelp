//
//  MainViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseDatabase
import MBProgressHUD
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var databaseRef: FIRDatabaseReference!
    
    var posts: [Post]!
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Posts"
    
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        databaseRef = FIRDatabase.database().reference()
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        doSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        // doSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        doSearch()
        
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        FBSDKLoginManager().logOut()
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogoutNotification"), object: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if posts != nil {
            return posts.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        if (self.posts[indexPath.row] as? Post) != nil {
            cell.post = self.posts[indexPath.row]
        }
        
        cell.selectionStyle = .none
        
        cell.viewController = self
        
        return cell
    }
    
    func doSearch() {
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        databaseRef.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            if let posts = snapshot.value as? NSDictionary {
                
                var dictionaries: [NSDictionary] = []
                
                for post in posts {
                    dictionaries.append([post.key : post.value])
                }
                
                self.posts = Post.postsWithArray(dictionaries: dictionaries)
                
                self.tableView.reloadData()
                
                self.refreshControl?.endRefreshing()
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        })

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let cell = sender as! PostTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            print(indexPath!.row)
            print("Post: \(posts![indexPath!.row])")
            
            let post = posts![indexPath!.row]
            
            let detailViewController = segue.destination as! PostDetailViewController
            
            detailViewController.post = post
            
            detailViewController.navigationItem.title = "Post Detail"
        
            // Deselect collection view after segue
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
