//
//  BusinessDetail.swift
//  Yep
//
//  Created by Angela Yu on 9/24/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class BusinessDetail: NSObject {
    let id: String?
    let name: String?
    let address: String?
    let phone: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    let reviewExcerpt: String?
    var reviewerImageURL: URL?
    var reviewer: String?
    var reviewRatingImageURL: URL?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        id = dictionary["id"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["display_address"] as? [String]
            if addressArray != nil && addressArray!.count > 0 {
                for field in addressArray! {
                    address += field
                    address += "\n"
                }
            let addressLen = address.index(address.endIndex, offsetBy: -1)
            let addressRange = address.startIndex ..< addressLen
            address = address[addressRange]
            }
        }
        self.address = address
        
        phone = dictionary["display_phone"] as? String
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        
        let reviewArray = dictionary["reviews"] as? NSArray
        if reviewArray != nil {
            let reviewDict = reviewArray![0] as? NSDictionary
            if reviewDict != nil {
                reviewExcerpt = reviewDict!["excerpt"] as? String
                let reviewRatingURLString = reviewDict!["rating_image_url"] as? String
                if reviewRatingURLString != nil {
                    reviewRatingImageURL = URL(string: reviewRatingURLString!)!
                } else {
                    reviewRatingImageURL = nil
                }
                let userDict = reviewDict!["user"] as? NSDictionary
                if userDict != nil {
                    reviewer = userDict!["name"] as? String
                    let userURLString = userDict!["image_url"] as? String
                    if userURLString != nil {
                        reviewerImageURL = URL(string: userURLString!)!
                    } else {
                        reviewerImageURL = nil
                    }
                } else {
                    reviewer = nil
                }
            } else {
                reviewExcerpt = nil
            }
        } else {
            reviewExcerpt = nil
            reviewRatingImageURL = nil
            reviewer = nil
            reviewerImageURL = nil
        }
    }
    
    class func getBusiness(id: String, completion: @escaping (BusinessDetail?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.getBusiness(id, completion: completion)
    }

}
