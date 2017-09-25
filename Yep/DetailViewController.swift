//
//  DetailViewController.swift
//  Yep
//
//  Created by Angela Yu on 9/24/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var reviewerLabel: UILabel!
    @IBOutlet weak var reviewRatingImageView: UIImageView!
    @IBOutlet weak var reviewExcerptLabel: UILabel!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var reviewFrameView: UIView!
    
    var businessID: String!
    var business: BusinessDetail! {
        didSet {
            heroImageView.setImageWith(business.imageURL!)
            nameLabel.text = business.name
            ratingImageView.setImageWith(business.ratingImageURL!)
            reviewCountLabel.text = "\(business.reviewCount!) reviews"
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            phoneLabel.text = business.phone
            reviewImageView.setImageWith(business.reviewerImageURL!)
            reviewerLabel.text = business.reviewer
            reviewRatingImageView.setImageWith(business.reviewRatingImageURL!)
            reviewExcerptLabel.text = business.reviewExcerpt
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(businessID)
        BusinessDetail.getBusiness(id: businessID, completion: { (resultBusiness: BusinessDetail?, error: Error?) -> Void in
            self.business = resultBusiness
        })
        detailScrollView.contentSize = CGSize(width: detailScrollView.frame.size.width, height: reviewFrameView.frame.origin.y + reviewFrameView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
