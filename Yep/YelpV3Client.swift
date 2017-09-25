//
//  YelpV3Client.swift
//  Yep
//
//  Created by Angela Yu on 9/24/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//
let yepConsumerKey = "_v7OGQx7u2n4dlE4RMr6ZA"
let yepConsumerSecret = "Fkil69LWAEJWefqNhcvFu3CKXDJQb6Wfrp8nEtya8qjalKG7aE39fPO36PzhFRft"

import UIKit
import BDBOAuth1Manager

class YelpV3Client: BDBOAuth1RequestOperationManager {
    static let sharedClient = YelpV3Client(consumerKey: yepConsumerKey, consumerSecret: yepConsumerSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String) {
        super.init(baseURL: URL(string: "https://api.yelp.com/v3/"), consumerKey: key, consumerSecret: secret)
        
        self.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "yep://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the token")
            let token = requestToken
            self.requestSerializer.saveAccessToken(token)
        }) { (error: Error!) -> Void in
            print("error: \(error.localizedDescription)")
        }
    }
    
    // API v3
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, distance: nil, offset: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: Float?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: sort, categories: categories, deals: deals, distance: distance, offset: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: Float?, offset: Int?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see https://www.yelp.com/developers/documentation/v3/business_search
        
        // Default the location to Palo Alto
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "latitude": 37.4419 as AnyObject, "longitude": -122.1430 as AnyObject]
        
        if sort != nil {
            parameters["sort_by"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["categories"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["attributes"] = deals! as AnyObject?
        }
        
        if distance != nil {
            parameters["radius"] = distance! as AnyObject?
        }
        
        if offset != nil {
            parameters["offset"] = offset! as AnyObject?
        }
        
        print(parameters)
        
        return self.get("business/search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
        })!
    }
}
