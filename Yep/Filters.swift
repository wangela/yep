//
//  Filters.swift
//  Yep
//
//  Created by Angela Yu on 9/20/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class Filters: NSObject {
    var deals: Bool?
    var sort: YelpSortMode?
    var distance: Float? // in meters
    var categories: [String]?
    
}
