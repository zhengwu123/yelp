//
//  TableCell.swift
//  Yelp
//
//  Created by zheng wu on 1/30/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class TableCell: UITableViewCell {
    
    @IBOutlet var foodType: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var reviews: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var starimage: UIImageView!
    @IBOutlet var photoImage:UIImageView!
    
    var business: Business!{
        
        didSet{
            title.text = business.name
            
            photoImage.setImageWith((business.imageURL)! as URL)
            foodType.text = business.categories
            distance.text = business.distance
            reviews.text = "\(business.reviewCount!) reviews"
            starimage.setImageWith(business.ratingImageURL! as URL)
            addressLabel.text = business.address
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImage.layer.cornerRadius = 5
        photoImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

