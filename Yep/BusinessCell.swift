//
//  BusinessCell.swift
//  Yep
//
//  Created by Angela Yu on 9/19/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!

    var business: Business! {
        didSet {
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) reviews"
            categoriesLabel.text = business.categories
            thumbImageView.setImageWith(business.imageURL!)
            ratingImageView.setImageWith(business.ratingImageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
