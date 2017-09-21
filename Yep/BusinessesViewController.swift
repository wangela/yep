//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, FiltersViewControllerDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchController: UISearchController!
    
    var defaultFilters = Filters()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Restaurants", sort: YelpSortMode.highestRated, categories: [], deals: false, completion: { (resultBusinesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = resultBusinesses
            self.filteredBusinesses = resultBusinesses
            self.resultsTableView.reloadData()
        }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let displayBusinesses = filteredBusinesses else {
            return 0
        }
        
        return displayBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        if let displayBusinesses = filteredBusinesses {
            cell.business = displayBusinesses[indexPath.row]
        }

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            Business.searchWithTerm(term: searchText, sort: .highestRated, categories: [], deals: false, completion: { (resultBusinesses: [Business]?, error: Error?) -> Void in
                
                self.filteredBusinesses = resultBusinesses
            }
            )
        } else {
            filteredBusinesses = businesses
        }
        resultsTableView.reloadData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    internal func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters) {
        let categories = filters.categories
        Business.searchWithTerm(term: "Bakeries", sort: YelpSortMode.highestRated, categories: categories, deals: true, completion: { (resultBusinesses: [Business]?, error: Error?) -> Void in
            self.businesses = resultBusinesses
            self.filteredBusinesses = resultBusinesses
            self.resultsTableView.reloadData()
        }
        )
    }
    
}
