//
//  DetailViewController.swift
//  Yelp
//
//  Created by New on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet var miles: UILabel!
    @IBOutlet var bigImage: UIImageView!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var reviewCounts: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var starImage: UIImageView!
    
    var business: Business!
    
    var milesText: String!
    var nameText: String!
    var addressText: String!
    var reviewCountsText: String!
    var voteCountLabelText: String!
    var starImageURL: NSURL!
    var BigImageURL: NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = 800
        scrollView.contentSize.width = self.scrollView.frame.width
        // Do any additional setup after loading the view.
        self.miles.text = business.distance
        self.name.text = business.name
        self.reviewCounts.text = "\(business.reviewCount!) reviews"
      //  print(starImageURL)
       self.starImage.setImageWith(business.ratingImageURL! as URL)
       self.bigImage.setImageWith(business.imageURL as! URL)
        self.address.text = business.address
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
