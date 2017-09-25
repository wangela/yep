//
//  V3Business.swift
//  Yep
//
//  Created by Angela Yu on 9/24/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class V3Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let rating: String?
    let reviewCount: NSNumber?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let address1 = location?["address1"] as? String
            if address1 != nil {
                address = location?["address1"] as? String
            }
            let city = location?["city"] as? String
            if city != nil {
                address += ", \(city)"
            }
        }
        self.address = address
        
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
        
        let ratingNumber = dictionary["rating"] as? NSNumber
        if ratingNumber != nil {
            rating = String(format: "%f", ratingNumber)
        } else {
            rating = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }

}
