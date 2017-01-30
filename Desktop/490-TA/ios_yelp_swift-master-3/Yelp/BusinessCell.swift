//
//  BusinessCell.swift
//  Yelp
//
//  Created by zheng wu on 1/29/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet var catagoriesLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var reviewCountsLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var reviewImage: UIImageView!
    @IBOutlet var businessName: UILabel!
    @IBOutlet var BusinessImage: UIImageView!
    var business: Business!{
        didSet{
        businessName.text = business.name
        BusinessImage.setImageWith(business.imageURL!)
        reviewImage.setImageWith(business.ratingImageURL!)
        catagoriesLabel.text = business.categories
        addressLabel.text = business.address
        reviewCountsLabel.text = "\(business.reviewCount!) Reviews"
        distanceLabel.text = business.distance
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BusinessImage.layer.cornerRadius = 5
        BusinessImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
