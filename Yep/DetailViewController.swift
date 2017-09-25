//
//  DetailViewController.swift
//  Yep
//
//  Created by Angela Yu on 9/24/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var businessID: String!
    var business: BusinessDetail! {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(businessID)
        BusinessDetail.getBusiness(id: businessID, completion: { (resultBusiness: BusinessDetail?, error: Error?) -> Void in
            self.business = resultBusiness
        })
        print (business)
        
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
