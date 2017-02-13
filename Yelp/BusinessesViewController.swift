//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,filterViewControllerDelegate ,UISearchBarDelegate, UIScrollViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    
    var businesses: [Business]!
    var nameText = ""
    var address = ""
    var miles = ""
    var  reviewcounts : NSNumber!
    var starimageURL: NSURL!
    var bigimageURL: NSURL!
    
    
    override func viewDidLoad() {
        //create a searchBar in navigation controller
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
        }
        )

        
        /* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        
        for business in businesses {
        print(business.name!)
        print(business.address!)
        }
        }
        */
        searchBar.delegate = self
        Search(searchTerm: "Restaurants")
    }
    var inputText = ""
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputText = searchText
        Search(searchTerm: inputText)
        
        tableView.reloadData()
    }
    
    
    func Search(searchTerm: String) {
        Business.searchWithTerm(term: searchTerm, sort: .distance, categories: [], deals: true) { (businesses: [Business]?, error: Error?) -> Void in
            if(searchTerm != ""){
                self.businesses = businesses
            }
            self.tableView.reloadData()
        }
    }
    

    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! TableCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filter"  {
            let navigationController = segue.destination as! UINavigationController
            let filterViewController = navigationController.topViewController as! FilterViewController
            filterViewController.delegate = self
        }
        
        if segue.identifier == "toDetail"  {
            let detialViewControllerInstance = segue.destination as! DetailViewController
                let cell = sender as! TableCell
            let indexPath = tableView.indexPath(for: cell)
            let business = businesses![(indexPath?.row)!]
            print(business)
            detialViewControllerInstance.business = business
            
        }
    }
    

        
        

    
    func filtersViewController(filtersViewController: FilterViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as! [String]
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: nil) { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
    }
    //implement infinite Scroll
    
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // ... Code to load more results ...
                Search(searchTerm: "Restaurants")
            }
        }
    }
}


